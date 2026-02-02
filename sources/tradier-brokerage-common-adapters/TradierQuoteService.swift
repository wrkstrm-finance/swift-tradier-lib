import CommonBroker
import Foundation
import TradierLib
import WrkstrmFoundation
import WrkstrmMain
import WrkstrmNetworking

public protocol TradierQuoteClient: Sendable {
  var serviceName: String { get }
  func quote(for symbol: String) async throws -> Tradier.Quote
  func quotes(for symbols: [String]) async throws -> [Tradier.Quote]
}

extension Tradier.CodableService: @preconcurrency TradierQuoteClient {
  public var serviceName: String { "Tradier" }
}

public struct TradierSandboxQuoteService: CommonQuoteService, CommonQuoteVariantService, Sendable {
  private let client: any TradierQuoteClient
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType = .sandbox

  public init(environment: Tradier.HTTPSSandboxEnvironment = .init()) {
    client = Tradier.CodableService(environment: environment)
  }

  /// Instrumented initializer allowing a custom JSON parser.
  public init(environment: Tradier.HTTPSSandboxEnvironment = .init(), parser: JSON.Parser) {
    client = Tradier.CodableService(environment: environment, json: parser)
  }

  #if DEBUG
  // Test-only initializer for injecting mocks (only in debug/testing builds)
  public init(client: any TradierQuoteClient) { self.client = client }
  #endif

  public func quote(for symbol: String, accountId _: String) async throws -> CommonQuoteVariant {
    let tradierQuote: Tradier.Quote = try await client.quote(for: symbol)
    return CommonQuoteVariant(tradierQuote)
  }

  public func quotes(for symbols: [String], accountId _: String) async throws
    -> [CommonQuoteVariant]
  {
    let tradierQuotes: [Tradier.Quote] = try await client.quotes(for: symbols)
    return tradierQuotes.map(CommonQuoteVariant.init)
  }

  // MARK: - CommonQuoteVariantService

  public func quoteVariant(
    for symbol: String,
    accountId _: String,
    detail: QuoteDetail,
  ) async throws -> CommonQuoteVariant {
    let q: Tradier.Quote = try await client.quote(for: symbol)
    switch detail {
    case .full:
      return CommonQuoteVariant(q)

    case .slim:
      let detailed = CommonQuoteDetailed(CommonQuote(q))
      return .slim(detailed.essentials)
    }
  }

  public func quotesVariant(
    for symbols: [String],
    accountId _: String,
    detail: QuoteDetail,
  ) async throws -> [CommonQuoteVariant] {
    let quotes: [Tradier.Quote] = try await client.quotes(for: symbols)
    switch detail {
    case .full:
      return quotes.map(CommonQuoteVariant.init)

    case .slim:
      return quotes.map { .slim(CommonQuoteEssentials(CommonQuoteDetailed(CommonQuote($0)))) }
    }
  }
}
