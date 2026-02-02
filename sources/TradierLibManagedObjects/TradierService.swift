import Foundation
import TradierLib
import WrkstrmNetworking

#if canImport(CoreData)
import CoreData
#endif
#if canImport(UIKit)
import UIKit
#endif

#if canImport(CoreData)
public struct ManagedSingleQuoteRequest: HTTP.CodableURLRequest {
  public typealias ResponseType = Managed.QuotesRoot
  public var method: HTTP.Method { .get }
  public var path: String { "markets/quotes" }
  public var options: HTTP.Request.Options

  public init(symbols: [String]) {
    options = .make { q in q.addJoined("symbols", values: symbols) }
  }
}

public struct ManagedTimeSalesRequest: HTTP.CodableURLRequest {
  public typealias ResponseType = ManagedSeries
  public var method: HTTP.Method { .get }
  public var path: String { "markets/timesales" }
  public var options: HTTP.Request.Options

  public init(symbol: String, interval: Tradier.Interval) {
    options = .make { q in
      q.add("symbol", value: symbol)
      q.add("interval", value: interval.rawValue)
    }
  }
}
#endif

extension Tradier {
  public actor ManagedService {
    public enum Environment: Sendable {
      case production
      case sandbox
    }

    public let client: HTTP.CodableClient

    public init(
      decoder: JSONDecoder,
      apiKey: String? = nil,
      environment: Environment = .sandbox,
    ) {
      let env: HTTP.Environment =
        switch environment {
        case .production:
          Tradier.HTTPSProdEnvironment(apiKey: apiKey)

        case .sandbox:
          Tradier.HTTPSSandboxEnvironment(apiKey: apiKey)
        }
      client = HTTP.CodableClient(
        environment: env,
        json: (requestEncoder: .commonDateFormatting, responseDecoder: decoder),
      )
    }
  }
}

#if canImport(CoreData)
extension Tradier.ManagedService {
  @MainActor
  public static func make(
    with context: NSManagedObjectContext,
    apiKey: String? = nil,
    environment: Environment = .sandbox,
  ) -> Self {
    let decoder: JSONDecoder = Managed.decoder(with: context)
    return .init(decoder: decoder, apiKey: apiKey, environment: environment)
  }
}
#endif  // canImport(CoreData)
