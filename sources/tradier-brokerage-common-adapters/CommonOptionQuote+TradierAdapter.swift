import Foundation
import CommonBroker
import TradierLib

extension CommonOptionQuote {
  public init(_ q: Tradier.Quote) {
    let expirationDate: Date?
    // Parse ISO yyyy-MM-dd expiration if present
    if let s = q.expirationDate {
      let f = DateFormatter()
      f.calendar = Calendar(identifier: .gregorian)
      f.locale = Locale(identifier: "en_US_POSIX")
      f.timeZone = TimeZone(secondsFromGMT: 0)
      f.dateFormat = "yyyy-MM-dd"
      expirationDate = f.date(from: s)
    } else {
      expirationDate = nil
    }
    let greeks: Greeks?
    if let g = q.greeks {
      greeks = Greeks(
        delta: g.delta,
        gamma: g.gamma,
        theta: g.theta,
        vega: g.vega,
        rho: g.rho,
        iv: g.midIv,
        bidIv: g.bidIv,
        midIv: g.midIv,
        askIv: g.askIv,
        updatedAt: g.updatedAt,
      )
    } else {
      greeks = nil
    }

    self.init(
      symbol: q.symbol,
      underlying: q.underlying,
      last: q.last,
      bid: q.bid,
      ask: q.ask,
      strike: q.strike,
      expirationDate: expirationDate,
      optionType: q.optionType,
      greeks: greeks,
    )
  }
}
