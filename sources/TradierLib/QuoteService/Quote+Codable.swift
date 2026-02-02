import Foundation

/// A namespace containing models for interacting with the Tradier API.
///
/// The Tradier namespace provides models for accessing market data including:
/// - Real-time quotes
/// - Time series data
/// - Price movement analysis
///
/// You typically use these models when deserializing responses from the Tradier API endpoints.
extension Tradier {
  /// The granularity of time series data.
  public enum Interval: String, Sendable {
    /// Trade-by-trade data
    case tick
    /// One minute intervals
    case oneMin = "1min"
    /// Five minute intervals
    case fiveMin = "5min"
  }

  /// A container for quote response data from the Tradier API.
  ///
  /// This type maps to the root level of the JSON response:
  /// ```json
  /// {
  ///    "quotes": {
  ///       "quote": { ... }
  ///    }
  /// }
  /// ```
  public struct SingleQuoteRoot: Decodable, Sendable {
    /// The quotes container holding the actual quote data.
    public var quotes: Quotes?
  }

  public struct MultiQuotesRoot: Decodable, Sendable {
    /// The quotes container holding the actual quote data.
    public var quotes: MultiQuotes?
  }

  /// A wrapper containing individual quote data.
  public struct MultiQuotes: Decodable, Sendable {
    /// The quote information for a security.
    public var quote: [Quote]?
  }

  /// A wrapper containing individual quote data.
  public struct Quotes: Decodable, Sendable {
    /// The quote information for a security.
    public var quote: Quote?
  }

  /// A comprehensive snapshot of market data for a security.
  ///
  /// The `Quote` type contains real-time market data including:
  /// - Current pricing and trading activity
  /// - Best bid/ask quotes
  /// - Historical metrics like 52-week highs and lows
  ///
  /// Example decoding from JSON:
  /// ```swift
  /// let quoteData = // ... JSON data from API
  /// let quoteResponse = try JSONDecoder().decode(QuotesRoot.self, from: quoteData)
  /// let quote = quoteResponse.quotes?.quote
  /// print("Current price: \(quote.last)")
  /// ```
  public struct Quote: Decodable, Hashable, Sendable {
    /// Optional identifier for the quote.
    public var id: Int?

    /// The ticker symbol for the security.
    public var symbol: String

    /// A description of the security, typically the company name.
    public var description: String

    /// The exchange where the security is traded.
    public var exch: String

    /// The type of security (e.g., stock, ETF).
    public var type: String

    /// The price of the most recent trade.
    public var last: Double?

    /// The change in price from the previous close.
    public var change: Double?

    /// The total trading volume for the current session.
    public var volume: Double

    /// The opening price for the current session, if available.
    public var open: Double?

    /// The highest traded price in the current session, if available.
    public var high: Double?

    /// The lowest traded price in the current session, if available.
    public var low: Double?

    /// The closing price, if available.
    public var close: Double?

    /// The current best bid price.
    public var bid: Double?

    /// The current best ask price.
    public var ask: Double?

    /// The percentage change in price from the previous close.
    public var changePercentage: Double?

    /// The average daily trading volume.
    public var averageVolume: Double?

    /// The volume of the most recent trade.
    public var lastVolume: Double

    /// The date of the most recent trade as a Unix timestamp.
    public var tradeDate: Int

    /// The closing price from the previous trading session.
    public var prevclose: Double?

    /// The highest traded price in the last 52 weeks.
    public var week52High: Double?

    /// The lowest traded price in the last 52 weeks.
    public var week52Low: Double?

    /// The size of the current best bid in lots of 100 shares.
    public var bidsize: Double

    /// The exchange where the current best bid originated.
    public var bidexch: String?

    /// The timestamp of the current best bid.
    public var bidDate: Int

    /// The size of the current best ask in lots of 100 shares.
    public var asksize: Double

    /// The exchange where the current best ask originated.
    public var askexch: String?

    /// The timestamp of the current best ask.
    public var askDate: Int

    /// Related derivative symbol.
    public var rootSymbol: String?

    public var symbolDescription: String?

    /// The underlying symbol for the option.
    public var underlying: String?

    /// The option's strike price.
    public var strike: Double?

    /// Current open interest for the contract.
    public var openInterest: Int?

    /// Contract size multiplier.
    public var contractSize: Int?

    /// The option's expiration date.
    public var expirationDate: String?

    /// Expiration type such as standard or weekly.
    public var expirationType: String?

    /// The option type, call or put.
    public var optionType: String?

    /// Calculated option Greeks.
    public var greeks: Greeks?

    private enum CodingKeys: String, CodingKey {
      case id, symbol, description, exch, type, last, change, volume, open, high, low, close, bid,
        ask
      case changePercentage = "change_percentage"
      case averageVolume = "average_volume"
      case lastVolume = "last_volume"
      case tradeDate = "trade_date"
      case prevclose
      case week52High = "week_52_high"
      case week52Low = "week_52_low"
      case bidsize
      case bidexch
      case bidDate = "bid_date"
      case asksize
      case askexch
      case askDate = "ask_date"
      case rootSymbol = "root_symbol"
      case symbolDescription = "symbol_description"
      case underlying, strike
      case openInterest = "open_interest"
      case contractSize = "contract_size"
      case expirationDate = "expiration_date"
      case expirationType = "expiration_type"
      case optionType = "option_type"
      case greeks
    }
  }

  /// Sensitivity measures for option pricing.
  public struct Greeks: Codable, Hashable, Sendable {
    public var delta: Double?
    public var gamma: Double?
    public var theta: Double?
    public var vega: Double?
    public var rho: Double?
    public var phi: Double?
    public var bidIv: Double?
    public var midIv: Double?
    public var askIv: Double?
    public var smvVol: Double?
    public var updatedAt: Date?

    private enum CodingKeys: String, CodingKey {
      case delta, gamma, theta, vega, rho, phi
      case bidIv = "bid_iv"
      case midIv = "mid_iv"
      case askIv = "ask_iv"
      case smvVol = "smv_vol"
      case updatedAt = "updated_at"
    }

    // Example: "2024-06-01T12:34:56Z" (ISO8601)
    private static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      return formatter
    }()

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      delta = try container.decodeIfPresent(Double.self, forKey: .delta)
      gamma = try container.decodeIfPresent(Double.self, forKey: .gamma)
      theta = try container.decodeIfPresent(Double.self, forKey: .theta)
      vega = try container.decodeIfPresent(Double.self, forKey: .vega)
      rho = try container.decodeIfPresent(Double.self, forKey: .rho)
      phi = try container.decodeIfPresent(Double.self, forKey: .phi)
      bidIv = try container.decodeIfPresent(Double.self, forKey: .bidIv)
      midIv = try container.decodeIfPresent(Double.self, forKey: .midIv)
      askIv = try container.decodeIfPresent(Double.self, forKey: .askIv)
      smvVol = try container.decodeIfPresent(Double.self, forKey: .smvVol)
      if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
        updatedAt = Greeks.dateFormatter.date(from: updatedAtString)
      } else {
        updatedAt = nil
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encodeIfPresent(delta, forKey: .delta)
      try container.encodeIfPresent(gamma, forKey: .gamma)
      try container.encodeIfPresent(theta, forKey: .theta)
      try container.encodeIfPresent(vega, forKey: .vega)
      try container.encodeIfPresent(rho, forKey: .rho)
      try container.encodeIfPresent(phi, forKey: .phi)
      try container.encodeIfPresent(bidIv, forKey: .bidIv)
      try container.encodeIfPresent(midIv, forKey: .midIv)
      try container.encodeIfPresent(askIv, forKey: .askIv)
      try container.encodeIfPresent(smvVol, forKey: .smvVol)
      if let updatedAt {
        let dateString = Greeks.dateFormatter.string(from: updatedAt)
        try container.encode(dateString, forKey: .updatedAt)
      }
    }
  }

  /// A container for time series market data.
  public struct Series: Decodable, Sendable {
    /// The series data wrapper.
    public var series: Data
  }

  /// A wrapper for time series data points.
  public struct Data: Decodable, Sendable {
    /// An array of time interval market data points.
    public var data: [TimeSale]
  }

  /// A market data point representing trading activity over a time interval.
  ///
  /// `TimeSale` provides OHLCV (Open, High, Low, Close, Volume) data for a specific time period.
  /// The interval can be tick-by-tick, one minute, or five minutes.
  public struct TimeSale: Comparable, Decodable, Sendable {
    /// Compares two time sales based on their timestamps.
    public static func < (lhs: TimeSale, rhs: TimeSale) -> Bool {
      (lhs.timestamp ?? 0) < (rhs.timestamp ?? 0)
    }

    /// The timestamp of the interval.
    public var time: Date

    /// The Unix timestamp of the interval.
    public var timestamp: Int?

    /// The trade price during this interval.
    public var price: Double?

    /// The first traded price in the interval.
    public var open: Double

    /// The highest traded price in the interval.
    public var high: Double

    /// The lowest traded price in the interval.
    public var low: Double

    /// The last traded price in the interval.
    public var close: Double

    /// The total trading volume during the interval.
    public var volume: Double

    /// The volume-weighted average price for the interval.
    public var vwap: Double

    /// Keys for encoding and decoding TimeSale data.
    public enum CodingKeys: String, CodingKey {
      case time
      case timestamp
      case price
      case open
      case high
      case low
      case close
      case volume
      case vwap
    }

    /// The minimum price observed during this interval.
    public var min: Double { [open, high, low, close].min()! }

    /// The maximum price observed during this interval.
    public var max: Double { [open, high, low, close].max()! }
  }

  /// A model representing a directional price movement segment.
  ///
  /// `Leg` analyzes price movements by tracking:
  /// - Time boundaries of the movement
  /// - Price levels and direction
  /// - Volume and wave patterns
  public struct Leg: Decodable, Sendable {
    /// The starting time of the price movement.
    public var firstTime: Date

    /// The ending time from last update.
    public var lastTime: Date

    /// The final ending time.
    public var endTime: Date

    /// Indicates if this is an upward (1) or downward (0) movement.
    public var isUp: UInt8

    /// The starting interval index of this movement.
    public var startInterval: Float

    /// The lowest price observed during this movement.
    public var low: Float

    /// The highest price observed during this movement.
    public var high: Float

    /// The price at the start of the movement.
    public var open: Float

    /// The price at the end of the movement.
    public var close: Float

    /// The total trading volume during this movement.
    public var volume: Float

    /// The number of base level wave patterns identified.
    public var numGen0: Int

    /// The total number of intervals in this movement.
    public var totalOpenIntervals: Float

    /// Keys for encoding and decoding Leg data.
    public enum CodingKeys: String, CodingKey {
      case firstTime = "time"
      case lastTime = "last_time"
      case isUp = "up"
      case startInterval = "start_interval"
      case endTime = "end_time"
      case low
      case high
      case open
      case close
      case volume
      case numGen0 = "num_gen0"
      case totalOpenIntervals = "total_open_intervals"
    }
  }
}
