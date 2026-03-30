import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain

public struct TradierProductionQuoteService: CommonQuoteService, CommonQuoteVariantService, Sendable
{
  private let client: any TradierQuoteClient
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType = .production

  public init(environment: Tradier.HTTPSProdEnvironment = .init()) {
    client = Tradier.CodableService(environment: environment)
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(
    environment: Tradier.HTTPSProdEnvironment = .init(),
    parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable
  ) {
    client = Tradier.CodableService(environment: environment, json: parser)
  }

  #if DEBUG
  // Test-only initializer for injecting mocks (only in debug/testing builds)
  public init(client: any TradierQuoteClient) { self.client = client }
  #endif

  public func quote(for symbol: String, accountId _: String) async throws -> CommonQuoteVariant {
    let tradierQuote: Tradier.TradierBrokerageQuoteModel = try await client.quote(for: symbol)
    return CommonQuoteVariant(tradierQuote)
  }

  public func quotes(for symbols: [String], accountId _: String) async throws
    -> [CommonQuoteVariant]
  {
    let tradierQuotes: [Tradier.TradierBrokerageQuoteModel] = try await client.quotes(for: symbols)
    return tradierQuotes.map(CommonQuoteVariant.init)
  }

  // MARK: - CommonQuoteVariantService

  public func quoteVariant(
    for symbol: String,
    accountId _: String,
    detail: QuoteDetail,
  ) async throws -> CommonQuoteVariant {
    let q: Tradier.TradierBrokerageQuoteModel = try await client.quote(for: symbol)
    switch detail {
    case .full:
      return CommonQuoteVariant(q)

    case .slim:
      let detailed = CommonBrokerageQuoteDetailedModel(CommonBrokerageQuoteModel(q))
      return .slim(detailed.essentials)
    }
  }

  public func quotesVariant(
    for symbols: [String],
    accountId _: String,
    detail: QuoteDetail,
  ) async throws -> [CommonQuoteVariant] {
    let quotes: [Tradier.TradierBrokerageQuoteModel] = try await client.quotes(for: symbols)
    switch detail {
    case .full:
      return quotes.map(CommonQuoteVariant.init)

    case .slim:
      return quotes.map { .slim(CommonBrokerageQuoteEssentialsModel(CommonBrokerageQuoteDetailedModel(CommonBrokerageQuoteModel($0)))) }
    }
  }
}
