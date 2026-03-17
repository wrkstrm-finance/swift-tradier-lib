import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

public struct TradierOptionQuoteCommonService: CommonOptionQuoteService, Sendable {
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType
  private let client: Tradier.CodableService

  public init(environment: HTTP.Environment) {
    client = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOptionQuoteCommonService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(
    environment: HTTP.Environment,
    parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable
  ) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOptionQuoteCommonService.")
    }
  }

  public func optionQuote(for symbol: String, accountId _: String) async throws -> CommonOptionQuote
  {
    let request = Tradier.MultiQuotesRequest(symbols: [symbol], greeks: true)
    let root: Tradier.MultiQuotesRoot = try await client.client.send(request)
    guard let q: Tradier.Quote = root.quotes?.quote?.first else {
      throw StringError("No option quote for \(symbol)")
    }
    return CommonOptionQuote(q)
  }
}
