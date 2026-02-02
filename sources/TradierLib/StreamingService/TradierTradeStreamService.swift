import Foundation
import NIOCore
import NIOHTTP1
import NIOPosix
import NotionLib
import WebSocketKit
import CommonLog

public actor TradierTradeStreamService {
  public static let notification: Notification.Name = .init("TradierTradeStreamServiceFill")

  private let accountId: String
  private let tradierToken: String
  private let notionToken: String
  private let notionDatabaseId: String
  private let journaler: (@Sendable (Tradier.Transaction) async -> Void)?
  private var task: Task<Void, Never>?
  private var group: MultiThreadedEventLoopGroup?
  private var socket: WebSocket?

  public init(
    accountId: String,
    tradierToken: String,
    notionToken: String,
    notionDatabaseId: String,
    journaler: (@Sendable (Tradier.Transaction) async -> Void)? = nil,
  ) {
    self.accountId = accountId
    self.tradierToken = tradierToken
    self.notionToken = notionToken
    self.notionDatabaseId = notionDatabaseId
    self.journaler = journaler
  }

  public func start() {
    task = Task { await connect() }
  }

  public func stop() {
    task?.cancel()
    task = nil
    Task {
      try? await socket?.close()
      socket = nil
      if let group {
        try? await group.shutdownGracefully()
      }
      group = nil
    }
  }

  private func connect() async {
    guard let url: URL = .init(string: "wss://ws.tradier.com/v1/accounts/events") else { return }
    let group: MultiThreadedEventLoopGroup = .init(numberOfThreads: 1)
    self.group = group
    do {
      let headers = HTTPHeaders([
        ("Authorization", "Bearer \(tradierToken)"),
        ("Accept", "application/json"),
      ])
      try await WebSocketKit.WebSocket.connect(
        to: url,
        headers: headers,
        on: group,
      ) { ws in
        await self.didConnect(ws)
      }
    } catch {
      Log.error("Stream failed: \(error.localizedDescription)")
    }
  }

  func handle(text: String) async {
    guard
      task?.isCancelled != true,
      let data: Data = text.data(using: .utf8),
      !data.isEmpty
    else { return }
    do {
      let event: AccountEvent = try JSONDecoder().decode(AccountEvent.self, from: data)
      if event.type == "fill", let transaction: Tradier.Transaction = event.transaction {
        if let journaler {
          await journaler(transaction)
        } else {
          await journal(transaction: transaction)
        }
        NotificationCenter.default.post(name: Self.notification, object: transaction)
      }
    } catch {
      Log.error("Stream decode failed: \(error.localizedDescription)")
    }
  }

  private func journal(transaction: Tradier.Transaction) async {
    let service: Notion.CodableService = .init(token: notionToken)
    let parentEnum: Notion.ParentEnum = .database(.init(notionDatabaseId))
    do {
      let data: Data = try JSONEncoder().encode(parentEnum)
      let parent: Notion.Parent = try JSONDecoder().decode(Notion.Parent.self, from: data)
      var props: [String: Notion.PageProperty] = [:]
      if let symbol: String = transaction.trade?.symbol {
        props["Name"] = .title(symbol)
      }
      if let quantity: Double = transaction.trade?.quantity {
        props["Quantity"] = .richText(String(quantity))
      }
      let body: Notion.PageCreateRequest.Body = .init(
        parent: parent,
        properties: props,
      )
      let request: Notion.PageCreateRequest = .init(body)
      _ = try await service.createPage(request)
    } catch {
      Log.error("Failed to journal trade: \(error.localizedDescription)")
    }
  }

  private func didConnect(_ ws: WebSocket) async {
    socket = ws
    ws.onText { [weak self] _, text in
      Task { await self?.handle(text: text) }
    }
    do {
      try await ws.send("account_id=\(accountId)")
      _ = try await ws.onClose.get()
    } catch {
      Log.error("Stream failed: \(error.localizedDescription)")
    }
  }
}
