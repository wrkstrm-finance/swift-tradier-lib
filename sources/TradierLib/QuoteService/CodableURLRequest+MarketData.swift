import Foundation
import CommonLog
import WrkstrmNetworking

extension Tradier {
  public struct ClockRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.ClockRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/clock" }
    public var options: HTTP.Request.Options

    public init() {
      options = .init()
    }
  }

  public struct QuoteRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.SingleQuoteRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/quotes" }
    public var options: HTTP.Request.Options

    public init(symbol: String, greeks: Bool = false) {
      options = .make { q in
        q.add("symbols", value: symbol)
        q.add("greeks", value: greeks ? true : nil)
      }
    }
  }

  public struct MultiQuotesRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.MultiQuotesRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/quotes" }
    public var options: HTTP.Request.Options

    public init(symbols: [String], greeks: Bool = false) {
      options = .make { q in
        q.addJoined("symbols", values: symbols)
        q.add("greeks", value: greeks ? true : nil)
      }
    }
  }

  public struct OptionChainRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = OptionChainRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/options/chains" }
    public var options: HTTP.Request.Options

    public init(symbol: String, expiration: String, greeks: Bool) {
      options = .make { q in
        q.add("symbol", value: symbol)
        q.add("expiration", value: expiration)
        q.add("greeks", value: greeks)
      }
    }
  }

  public struct OptionExpirationsRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = OptionExpirationsRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/options/expirations" }
    public var options: HTTP.Request.Options

    public init(
      symbol: String,
      includeAllRoots: Bool? = nil,
      strikes: Bool? = nil,
      contractSize: Int? = nil,
      expirationType: String? = nil,
    ) {
      options = .make { q in
        q.add("symbol", value: symbol)
        q.add("includeAllRoots", value: includeAllRoots)
        q.add("strikes", value: strikes)
        q.add("contractSize", value: contractSize)
        q.add("expirationType", value: expirationType)
      }
    }
  }

  public struct MarketCalendarRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.MarketCalendarRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/calendar" }
    public var options: HTTP.Request.Options

    public init(month: Int, year: Int) {
      options = .make { q in
        q.add("month", value: month)
        q.add("year", value: year)
      }
    }
  }

  public struct TimeSalesRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.Series
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
}
