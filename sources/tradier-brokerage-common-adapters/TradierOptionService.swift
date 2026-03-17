import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

// MARK: - Mapping Helpers

private enum _DateFmt {
  static let yyyyMMdd: DateFormatter = {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(secondsFromGMT: 0)
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()
}

extension CommonOptionExpiration {
  init(_ e: Option.Expiration) {
    let d = _DateFmt.yyyyMMdd.date(from: e.date) ?? Date(timeIntervalSince1970: 0)
    self.init(
      date: d,
      dateString: e.date,
      expirationType: e.expirationType,
      strikes: e.strikes,
    )
  }
}

extension CommonOptionKind {
  var tradierKind: Option.Kind { self == .call ? .call : .put }
}

// MARK: - Client Abstraction

public protocol TradierOptionDomainClient: Sendable {
  func optionExpirations(
    for symbol: String,
    includeAllRoots: Bool?,
    strikes: Bool,
    contractSize: Int?,
    expirationType: Bool,
  ) async throws -> [Option.Expiration]

  func optionQuotes(
    for symbol: String,
    expiration: Option.Expiration,
    kind: Option.Kind,
    maxStrikes: Int,
    includeGreeks: Bool,
  ) async throws -> [Tradier.Quote]

  func optionChain(
    for symbol: String,
    expiration: Option.Expiration,
    includeGreeks: Bool,
  ) async throws -> [Tradier.Quote]
}

extension Tradier.CodableService: TradierOptionDomainClient {}

// MARK: - Service

public struct TradierOptionService: CommonOptionService, Sendable {
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType

  private let client: any TradierOptionDomainClient

  public init(environment: HTTP.Environment) {
    let svc = Tradier.CodableService(environment: environment)
    client = svc
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOptionService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(environment: HTTP.Environment, parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable) {
    let svc = Tradier.CodableService(environment: environment, json: parser)
    client = svc
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOptionService.")
    }
  }

  #if DEBUG
  // Test-only initializer for injecting a mock client
  public init(client: any TradierOptionDomainClient, serviceType: ServiceType) {
    self.client = client
    self.serviceType = serviceType
  }
  #endif

  // MARK: - CommonOptionService

  public func expirations(for symbol: String) async throws -> [CommonOptionExpiration] {
    let exps = try await client.optionExpirations(
      for: symbol,
      includeAllRoots: nil,
      strikes: true,
      contractSize: nil,
      expirationType: true,
    )
    return exps.map(CommonOptionExpiration.init)
  }

  public func optionQuotes(
    for symbol: String,
    expiration: CommonOptionExpiration,
    kind: CommonOptionKind,
    maxStrikes: Int,
    includeGreeks: Bool,
  ) async throws -> [CommonOptionQuote] {
    let tradierExp: Option.Expiration = .init(
      date: expiration.dateString,
      expirationType: expiration.expirationType,
      strikes: expiration.strikes,
    )
    let quotes = try await client.optionQuotes(
      for: symbol,
      expiration: tradierExp,
      kind: kind.tradierKind,
      maxStrikes: maxStrikes,
      includeGreeks: includeGreeks,
    )
    return quotes.map(CommonOptionQuote.init)
  }

  public func optionChain(
    for symbol: String,
    expiration: CommonOptionExpiration,
    includeGreeks: Bool,
  ) async throws -> [CommonOptionQuote] {
    let tradierExp: Option.Expiration = .init(
      date: expiration.dateString,
      expirationType: expiration.expirationType,
      strikes: expiration.strikes,
    )
    let quotes = try await client.optionChain(
      for: symbol,
      expiration: tradierExp,
      includeGreeks: includeGreeks,
    )
    return quotes.map(CommonOptionQuote.init)
  }
}
