import Foundation
import WrkstrmFoundation
import CommonLog
import WrkstrmMain
import WrkstrmNetworking

extension Tradier {
  public actor CodableService: OptionQuoteService {
    /// Returns a shared instance if the TRADIER_API_KEY environment variable is set, otherwise nil.
    public static let sharedSandbox: CodableService? = .init(environment: HTTPSSandboxEnvironment())

    // TODO: make private again. Service should take care of
    // creating the right request and Swift object.
    public let client: HTTP.CodableClient

    // Lightweight cache.
    var optionExpirationsCache: [String: [Option.Expiration]] = [:]

    public init(environment: HTTP.Environment = HTTPSSandboxEnvironment()) {
      let decoder = JSONDecoder.commonDateParsing
      decoder.dateDecodingStrategy = .custom(Tradier.customDateDecoder)
      client = .init(environment: environment, json: (.commonDateFormatting, decoder))
    }

    #if DEBUG
    /// Test-only initializer allowing injection of a preconfigured HTTP client.
    public init(client: HTTP.CodableClient) {
      self.client = client
    }
    #endif

    /// Initializes with a custom JSON decoder (protocol-based) and optional encoder.
    /// - Parameters:
    ///   - environment: HTTP environment (sandbox/production).
    ///   - decoder: Response decoder conforming to `JSONDataDecoding`.
    ///   - encoder: Optional request encoder; defaults to `JSONEncoder.commonDateFormatting`.
    public init(
      environment: HTTP.Environment = HTTPSSandboxEnvironment(),
      decoder: any JSONDataDecoding,
      encoder: (any JSONDataEncoding)? = nil,
    ) {
      let coding = HTTP.CodableClient.SendableJSONCoding(
        requestEncoder: encoder ?? JSONEncoder.commonDateFormatting,
        responseDecoder: decoder
      )
      client = .init(
        environment: environment,
        jsonCoding: coding,
        transport: HTTP.URLSessionTransport(),
      )
    }

    /// Initializes with fully custom JSON coding tuple (protocol-based).
    /// - Parameters:
    ///   - environment: HTTP environment (sandbox/production).
    ///   - jsonCoding: Tuple containing request encoder and response decoder.
    public init(
      environment: HTTP.Environment = HTTPSSandboxEnvironment(),
      jsonCoding: (requestEncoder: any JSONDataEncoding, responseDecoder: any JSONDataDecoding),
    ) {
      let coding = HTTP.CodableClient.SendableJSONCoding(
        requestEncoder: jsonCoding.requestEncoder,
        responseDecoder: jsonCoding.responseDecoder
      )
      client = .init(
        environment: environment,
        jsonCoding: coding,
        transport: HTTP.URLSessionTransport(),
      )
    }

    /// Initializes using a JSON.Parser instance.
    public init(
      environment: HTTP.Environment = HTTPSSandboxEnvironment(),
      json: JSON.Parser,
    ) {
      client = HTTP.CodableClient(environment: environment, parser: json)
    }

    // Domain methods moved to per-service extensions.
  }
}
