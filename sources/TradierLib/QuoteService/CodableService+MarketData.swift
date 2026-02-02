// Overview: Per-domain market data methods for Tradier.CodableService.
// Provides quotes, time sales, options, and market calendar APIs.
// Related: Quote+Codable.swift, CodableURLRequest+MarketData.swift
import Foundation
import CommonLog
import WrkstrmMain
import WrkstrmNetworking

extension Tradier.CodableService {
  public func quote(for symbol: String) async throws -> Tradier.Quote {
    /// Returns the latest quote for a single symbol.
    let request: Tradier.QuoteRequest = .init(symbol: symbol)
    let response = try await client.send(request)
    guard let quote = response.quotes?.quote else {
      Log.info("Missing quote for \(symbol)")
      throw StringError("Not good.")
    }
    return quote
  }

  public func quotes(for symbols: [String]) async throws -> [Tradier.Quote] {
    /// Returns the latest quotes for multiple symbols.
    let request: Tradier.MultiQuotesRequest = .init(
      symbols: symbols,
      greeks: false,
    )
    let result: Tradier.MultiQuotesRoot = try await client.send(request)
    guard let quotes = result.quotes?.quote else {
      throw StringError("No quotes found.")
    }
    return quotes
  }

  public func clock() async throws -> Tradier.Clock {
    /// Fetches the market clock (open/close status and times).
    let request: Tradier.ClockRequest = .init()
    return try await client.send(request).clock
  }

  public func timeSales(
    for symbol: String,
    interval: Tradier.Interval,
  ) async throws -> [Tradier.TimeSale] {
    /// Retrieves time and sales series for a symbol at the requested interval.
    let request: Tradier.TimeSalesRequest = .init(symbol: symbol, interval: interval)
    return try await client.send(request).series.data
  }

  public func optionExpirations(
    for symbol: String,
    includeAllRoots: Bool? = nil,
    strikes: Bool = true,
    contractSize: Int?,
    expirationType: Bool = true,
  ) async throws -> [Option.Expiration] {
    /// Lists available option expirations for a root symbol (cached per symbol).
    if let cached: [Option.Expiration] = optionExpirationsCache[symbol] {
      return cached
    }
    let request: Tradier.OptionExpirationsRequest = .init(
      symbol: symbol,
      includeAllRoots: includeAllRoots,
      strikes: strikes,
      contractSize: contractSize,
      expirationType: expirationType ? "true" : nil,
    )
    let expiration = try await client.send(request).expirations.expiration
    optionExpirationsCache[symbol] = expiration
    return expiration
  }

  public func optionQuotes(
    for root: String,
    expiration: Option.Expiration,
    kind: Option.Kind,
    maxStrikes: Int = 5,
    includeGreeks: Bool = true,
  ) async throws -> [Tradier.Quote] {
    /// Fetches quotes for a subset of strikes at a given expiration and kind.
    let formatter: DateFormatter = .init()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyy-MM-dd"
    guard let date: Date = formatter.date(from: expiration.date) else {
      throw StringError("Error pasing date")
    }
    let strikes: [Double] = expiration.strikes
    let limited: [Double] = Array(strikes.prefix(maxStrikes))
    let symbols: [String] = limited.map { strike in
      let strikeDecimal = Decimal(strike)
      return Tradier.optionContract(
        root: root,
        expiration: date,
        kind: kind,
        strike: strikeDecimal,
        calendar: formatter.calendar,
      )
    }
    let request: Tradier.MultiQuotesRequest = .init(
      symbols: symbols,
      greeks: includeGreeks,
    )
    let result: Tradier.MultiQuotesRoot = try await client.send(request)
    guard let quotes = result.quotes?.quote else {
      throw StringError("No option quote in quotes.")
    }
    return quotes
  }

  public func optionChain(
    for root: String,
    expiration: Option.Expiration,
    includeGreeks: Bool = true,
  ) async throws -> [Tradier.Quote] {
    /// Fetches the full option chain for a root and expiration.
    let request = Tradier.OptionChainRequest(
      symbol: root,
      expiration: expiration.date,
      greeks: includeGreeks,
    )
    return try await client.send(request).options.option
  }

  public func marketCalendar(
    month: Int,
    year: Int,
  ) async throws -> [Tradier.MarketCalendarRoot.Day] {
    /// Gets the market calendar for a given month and year.
    let request: Tradier.MarketCalendarRequest = .init(month: month, year: year)
    return try await client.send(request).calendar.days.day
  }
}
