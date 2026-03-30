import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

/// Tradier-backed implementation for fetching a single option quote by OSI symbol.
/// Example symbol: "AAPL250118C00180000"
public struct TradierOptionQuoteService: CommonBroker.OptionQuoteService, Sendable {
  public typealias OptionQuote = Tradier.TradierBrokerageQuoteModel
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType
  private let service: Tradier.CodableService

  public init(environment: HTTP.Environment) {
    service = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOptionQuoteService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(
    environment: HTTP.Environment,
    parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable
  ) {
    service = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOptionQuoteService.")
    }
  }

  public func optionQuote(for symbol: String) async throws -> Tradier.TradierBrokerageQuoteModel {
    // Use multi-quote endpoint with greeks enabled for option symbols.
    let request = Tradier.MultiQuotesRequest(symbols: [symbol], greeks: true)

    // Disambiguate the response type for the decoder.
    let root: Tradier.TradierBrokerageMultiQuotesRootModel = try await service.client.send(request)

    // TradierBrokerageMultiQuotesRootModel -> TradierBrokerageMultiQuotesModel -> [TradierBrokerageQuoteModel]
    guard let quotes: [Tradier.TradierBrokerageQuoteModel] = root.quotes?.quote, !quotes.isEmpty else {
      throw StringError("No option quote for \(symbol)")
    }

    // Prefer exact symbol match if multiple quotes are returned.
    if let exact = quotes.first(where: { $0.symbol == symbol }) {
      return exact
    }

    // Fallback to the first quote.
    return quotes[0]
  }
}
