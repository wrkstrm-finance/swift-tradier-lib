import Foundation
import CommonBroker
import TradierLib

extension CommonQuote {
  /// Adapter from Tradier SDK model to CommonQuote.
  public init(_ tradierQuote: Tradier.Quote) {
    func secondsOrMillisToDate(_ value: Int?) -> Date? {
      guard let raw = value else { return nil }
      if raw > 1_000_000_000_000 { return Date(timeIntervalSince1970: TimeInterval(raw) / 1000.0) }
      return Date(timeIntervalSince1970: TimeInterval(raw))
    }
    func parseExpiration(_ value: String?) -> Date? {
      guard let value else { return nil }
      // Try yyyy-MM-dd first (Tradier expirations format)
      let df = DateFormatter()
      df.locale = Locale(identifier: "en_US_POSIX")
      df.timeZone = TimeZone(secondsFromGMT: 0)
      df.dateFormat = "yyyy-MM-dd"
      if let d = df.date(from: value) { return d }
      // Fallback: ISO8601
      let iso = ISO8601DateFormatter()
      return iso.date(from: value)
    }

    let bidDate = secondsOrMillisToDate(tradierQuote.bidDate)
    let askDate = secondsOrMillisToDate(tradierQuote.askDate)
    let tradeDate = secondsOrMillisToDate(tradierQuote.tradeDate)
    let expirationDate = parseExpiration(tradierQuote.expirationDate)

    let greeks: CommonGreeks?
    if let g = tradierQuote.greeks {
      greeks = CommonGreeks(
        delta: g.delta,
        gamma: g.gamma,
        theta: g.theta,
        vega: g.vega,
        rho: g.rho,
        phi: g.phi,
        bidIv: g.bidIv,
        midIv: g.midIv,
        askIv: g.askIv,
        smvVol: g.smvVol,
        updatedAt: g.updatedAt,
      )
    } else {
      greeks = nil
    }

    self.init(
      id: tradierQuote.id,
      type: tradierQuote.type,
      tradeDate: tradeDate,
      symbol: tradierQuote.symbol,
      symbolDescription: tradierQuote.symbolDescription,
      exch: tradierQuote.exch,
      last: tradierQuote.last,
      change: tradierQuote.change,
      changePercentage: tradierQuote.changePercentage,
      bid: tradierQuote.bid,
      bidsize: Int(tradierQuote.bidsize * 100),
      bidexch: tradierQuote.bidexch,
      bidDate: bidDate,
      ask: tradierQuote.ask,
      asksize: Int(tradierQuote.asksize * 100),
      askexch: tradierQuote.askexch,
      askDate: askDate,
      open: tradierQuote.open,
      high: tradierQuote.high,
      low: tradierQuote.low,
      close: tradierQuote.close,
      volume: Int(tradierQuote.volume),
      prevclose: tradierQuote.prevclose,
      week52High: tradierQuote.week52High,
      week52Low: tradierQuote.week52Low,
      averageVolume: Int(tradierQuote.averageVolume ?? 0),
      lastVolume: Int(tradierQuote.lastVolume),
      rootSymbol: tradierQuote.rootSymbol,
      underlying: tradierQuote.underlying,
      strike: tradierQuote.strike,
      openInterest: tradierQuote.openInterest,
      contractSize: tradierQuote.contractSize,
      expirationDate: expirationDate,
      expirationType: tradierQuote.expirationType,
      optionType: tradierQuote.optionType,
      greeks: greeks,
    )
  }
}
