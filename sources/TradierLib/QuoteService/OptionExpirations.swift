import Foundation
import SwiftUniversalFoundation
import WrkstrmNetworking

public protocol QuoteService: Sendable {
  func quote(for symbol: String) async throws -> Tradier.Quote

  func quotes(for symbols: [String]) async throws -> [Tradier.Quote]
}

public protocol OptionQuoteService: QuoteService, Sendable {
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

public enum Option {
  /// The type of option contract.
  ///
  /// Returns "C" for calls and "P" for puts when used in OCC OSI symbols.
  public enum Kind: String, Sendable {
    /// Call option.
    case call = "C"
    /// Put option.
    case put = "P"
  }

  public struct Expiration: Codable, Sendable {
    public var date: String
    public var expirationType: String
    public var strikes: [Double]

    enum CodingKeys: String, CodingKey {
      case date
      case expirationType = "expiration_type"
      case strikes
    }

    enum StrikesKeys: String, CodingKey {
      case strike
    }

    public init(date: String, expirationType: String, strikes: [Double]) {
      self.date = date
      self.expirationType = expirationType
      self.strikes = strikes
    }

    public init(from decoder: Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(
        keyedBy: CodingKeys.self,
      )
      date = try container.decode(String.self, forKey: .date)
      expirationType = try container.decode(
        String.self,
        forKey: .expirationType,
      )
      let strikesContainer: KeyedDecodingContainer<StrikesKeys>? =
        try? container
        .nestedContainer(
          keyedBy: StrikesKeys.self,
          forKey: .strikes,
        )
      strikes =
        try strikesContainer?.decode([Double].self, forKey: .strike) ?? []
    }

    public func encode(to encoder: Encoder) throws {
      var container: KeyedEncodingContainer<CodingKeys> = encoder.container(
        keyedBy: CodingKeys.self,
      )
      try container.encode(date, forKey: .date)
      try container.encode(expirationType, forKey: .expirationType)
      var strikesContainer: KeyedEncodingContainer<StrikesKeys> =
        container.nestedContainer(
          keyedBy: StrikesKeys.self,
          forKey: .strikes,
        )
      try strikesContainer.encode(strikes, forKey: .strike)
    }
  }
}

extension Tradier {
  public typealias OptionKind = Option.Kind
}

extension Tradier {
  public struct OptionExpirationsRoot: Codable, Sendable {
    public var expirations: Expirations

    public struct Expirations: Codable, Sendable {
      public var expiration: [Option.Expiration]
    }
  }

  public struct OptionChainRoot: Decodable, Sendable {
    public var options: Options

    public struct Options: Decodable, Sendable {
      public var option: [Quote]
    }
  }
}
