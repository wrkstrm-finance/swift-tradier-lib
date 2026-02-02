// Overview: Wire models and event enum for market streaming via WebSocket.
// Decoded by TradierEventsClient.decode(_:) to yield TradierEvent values.
import Foundation

/// Discriminated union of parsed market streaming messages.
public enum TradierEvent: @unchecked Sendable {
  case quote(Quote)
  case trade(Trade)
  case summary(Summary)
  case timesale(TimeSale)
  case tradex(TradeX)
  case unknown(String, [String: Any])

  /// Convenience accessor for the symbol, if present in the event.
  public var symbol: String? {
    switch self {
    case .quote(let q): q.symbol
    case .trade(let t): t.symbol
    case .summary(let s): s.symbol
    case .timesale(let t): t.symbol
    case .tradex(let t): t.symbol
    case .unknown: nil
    }
  }
}

/// Best bid/ask quote update.
public struct Quote: Codable, Sendable {
  public let type: String
  public let symbol: String
  public let bid: Double?
  public let bidsz: Int?
  public let bidexch: String?
  public let biddate: String?
  public let ask: Double?
  public let asksz: Int?
  public let askexch: String?
  public let askdate: String?
}

/// Trade print update.
public struct Trade: Codable, Sendable {
  public let type: String
  public let symbol: String
  public let exch: String?
  public let price: String?
  public let size: String?
  public let cvol: String?
  public let date: String?
  public let last: String?
}

/// Session summary update (open/high/low/prevClose).
public struct Summary: Codable, Sendable {
  public let type: String
  public let symbol: String
  public let open: String?
  public let high: String?
  public let low: String?
  public let prevClose: String?
}

/// Time and sales update including size and session.
public struct TimeSale: Codable, Sendable {
  public let type: String
  public let symbol: String
  public let exch: String?
  public let bid: String?
  public let ask: String?
  public let last: String?
  public let size: String?
  public let date: String?
  public let seq: Int?
  public let flag: String?
  public let cancel: Bool?
  public let correction: Bool?
  public let session: String?
}

/// Extended trade update with cumulative volume.
public struct TradeX: Codable, Sendable {
  public let type: String
  public let symbol: String
  public let exch: String?
  public let price: String?
  public let size: String?
  public let cvol: String?
  public let date: String?
  public let last: String?
}
