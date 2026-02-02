// Overview: WebSocket client for real-time market events from Tradier.
// Connects to events endpoint, handles upgrades, pings, decoding, and reconnection.
import CommonLog
import Foundation
import Logging
import NIO
import NIOHTTP1
import NIOSSL
import NIOWebSocket

private let log: Logger = {
  var logger = Logger(label: "TradierLib.Stream")
  logger.logLevel = .info
  return logger
}()

/// WebSocket client that emits `TradierEvent` values for market updates.
/// Use `connect` to subscribe and consume events via the `events` AsyncStream.
public final class TradierEventsClient: @unchecked Sendable {
  private var channel: Channel?
  private var eventLoopGroup: MultiThreadedEventLoopGroup
  private var pingTask: RepeatedTask?
  private let config: Config
  private let decoder: JSONDecoder = .init()
  private var lastPayload: String = "{}"
  private var continuation: AsyncStream<TradierEvent>.Continuation?
  public private(set) var events: AsyncStream<TradierEvent>

  /// Creates a client with endpoint configuration and thread count.
  /// - Parameters:
  ///   - config: Endpoint URL and optional auth header.
  ///   - threads: Number of NIO event loop threads to use.
  public init(config: Config, threads: Int = 1) {
    self.config = config
    var cont: AsyncStream<TradierEvent>.Continuation!
    events = AsyncStream(bufferingPolicy: .bufferingNewest(10000)) { cont = $0 }
    continuation = cont
    eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: max(1, threads))
  }

  /// Opens the WebSocket (if needed) and subscribes to the given symbols.
  /// - Parameters:
  ///   - sessionId: Tradier session id from the REST API.
  ///   - symbols: Symbols to stream (e.g. ["AAPL"]).
  ///   - filters: Optional event type filters.
  ///   - options: Stream behavior flags.
  public func connect(
    sessionId: String,
    symbols: [String],
    filters: [String]? = nil,
    options: TradierStreamOptions = .init(),
  ) async throws {
    try await openSocketIfNeeded()
    try await sendPayload(
      sessionId: sessionId,
      symbols: symbols,
      filters: filters,
      options: options,
    )
  }

  /// Updates the subscription with new symbols/filters/options.
  /// - Parameters:
  ///   - sessionId: Tradier session id.
  ///   - symbols: Symbols to stream.
  ///   - filters: Optional event type filters.
  ///   - options: Stream behavior flags.
  public func update(
    sessionId: String,
    symbols: [String],
    filters: [String]? = nil,
    options: TradierStreamOptions = .init(),
  ) async throws {
    try await sendPayload(
      sessionId: sessionId,
      symbols: symbols,
      filters: filters,
      options: options,
    )
  }

  /// Closes the WebSocket and shuts down the event loop group.
  public func close() async {
    pingTask?.cancel()
    pingTask = nil
    try? await channel?.close().get()
    channel = nil
    try? await eventLoopGroup.shutdownGracefully()
    continuation?.finish()
  }

  private func openSocketIfNeeded() async throws {
    if channel != nil { return }
    guard let host: String = config.url.host else { throw URLError(.badURL) }
    let port: Int = config.url.port ?? (config.url.scheme == "wss" ? 443 : 80)
    let path: String =
      config.url.path.isEmpty ? "/" : config.url.path + (config.url.query.map { "?\($0)" } ?? "")

    let bootstrap = ClientBootstrap(group: eventLoopGroup).channelInitializer {
      channel in
      let upgrader: NIOWebSocketClientUpgrader = .init(maxFrameSize: 1 << 20) { channel, _ in
        channel.pipeline.addHandler(
          WSInbound(
            onText: { [weak self] text in self?.handle(text: text) },
            onBinary: { _ in },
            onClose: { [weak self] error in Task { await self?.reconnect(error: error) } },
          ),
        )
      }
      let upgradeConfig: NIOHTTPClientUpgradeSendableConfiguration = (
        upgraders: [upgrader],
        completionHandler: { _ in },
      )
      let httpStages = channel.pipeline.addHTTPClientHandlers(withClientUpgrade: upgradeConfig)
      guard self.config.url.scheme == "wss" else { return httpStages }
      let tls = TLSConfiguration.makeClientConfiguration()
      let context: NIOSSLContext = try! NIOSSLContext(configuration: tls)
      let handler: NIOSSLClientHandler = try! NIOSSLClientHandler(
        context: context,
        serverHostname: host,
      )
      do {
        try channel.pipeline.syncOperations.addHandler(handler, position: .first)
      } catch {
        return channel.eventLoop.makeFailedFuture(error)
      }
      return httpStages
    }

    let ch: Channel = try await bootstrap.connect(host: host, port: port).get()
    channel = ch

    var head = HTTPRequestHead(version: .http1_1, method: .GET, uri: path)
    head.headers.add(name: "Host", value: host)
    head.headers.add(name: "Connection", value: "Upgrade")
    head.headers.add(name: "Upgrade", value: "websocket")
    head.headers.add(name: "Sec-WebSocket-Version", value: "13")
    head.headers.add(name: "Sec-WebSocket-Key", value: UUID().uuidString)
    if let auth: (name: String, value: String) = config.authHeader {
      head.headers.add(name: auth.name, value: auth.value)
    }

    ch.write(HTTPClientRequestPart.head(head), promise: nil)
    ch.writeAndFlush(HTTPClientRequestPart.end(nil), promise: nil)

    pingTask = ch.eventLoop.scheduleRepeatedTask(
      initialDelay: .seconds(15),
      delay: .seconds(15),
    ) { _ in
      let frame = WebSocketFrame(opcode: .ping, data: ch.allocator.buffer(capacity: 0))
      ch.writeAndFlush(frame, promise: nil)
    }
  }

  private func sendPayload(
    sessionId: String,
    symbols: [String],
    filters: [String]?,
    options: TradierStreamOptions,
  ) async throws {
    guard let ch: Channel = channel else { throw NIOSSLError.uncleanShutdown }
    let payload: [String: Any] = StreamingPayloadBuilder.build(
      sessionId: sessionId,
      symbols: symbols,
      filters: filters,
      options: options,
    )
    let data: Data = try JSONSerialization.data(withJSONObject: payload)
    guard let string = String(data: data, encoding: .utf8) else { return }
    lastPayload = string
    var buffer: ByteBuffer = ch.allocator.buffer(capacity: string.utf8.count)
    buffer.writeString(string)
    let frame = WebSocketFrame(fin: true, opcode: .text, data: buffer)
    ch.writeAndFlush(frame, promise: nil)
  }

  private func reconnect(error: Error?) async {
    log.warning("socket closed, reconnecting: \(String(describing: error))")
    var delay: Double = 1
    for _ in 0..<6 {
      try? await Task.sleep(
        nanoseconds: UInt64((delay + Double.random(in: 0...0.25)) * 1_000_000_000))
      do {
        try await openSocketIfNeeded()
        if !lastPayload.isEmpty { sendRaw(lastPayload) }
        log.info("reconnected")
        return
      } catch {
        delay = min(delay * 2, 30)
        continue
      }
    }
    log.critical("failed to reconnect after retries")
  }

  private func sendRaw(_ text: String) {
    guard let ch: Channel = channel else { return }
    var buffer: ByteBuffer = ch.allocator.buffer(capacity: text.utf8.count)
    buffer.writeString(text)
    let frame = WebSocketFrame(fin: true, opcode: .text, data: buffer)
    ch.writeAndFlush(frame, promise: nil)
  }

  func handle(text: String) {
    if let one: TradierEvent = decode(text) {
      continuation?.yield(one)
      return
    }
    for line in text.split(whereSeparator: \.isNewline) {
      if line.isEmpty { continue }
      if let event: TradierEvent = decode(String(line)) {
        continuation?.yield(event)
      }
    }
  }

  func decode(_ text: String) -> TradierEvent? {
    guard let data: Data = text.data(using: .utf8) else { return nil }
    if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
      let type: String = obj["type"] as? String
    {
      switch type {
      case "quote":
        if let value = try? decoder.decode(Quote.self, from: data) { return .quote(value) }

      case "trade":
        if let value = try? decoder.decode(Trade.self, from: data) { return .trade(value) }

      case "summary":
        if let value = try? decoder.decode(Summary.self, from: data) { return .summary(value) }

      case "timesale":
        if let value = try? decoder.decode(TimeSale.self, from: data) { return .timesale(value) }

      case "tradex":
        if let value = try? decoder.decode(TradeX.self, from: data) { return .tradex(value) }

      default:
        return .unknown(type, obj)
      }
    }
    return nil
  }
}
