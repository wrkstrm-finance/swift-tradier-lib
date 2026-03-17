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
        impliedVolatility: g.midIv,
        bidImpliedVolatility: g.bidIv,
        midImpliedVolatility: g.midIv,
        askImpliedVolatility: g.askIv,
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
      strikePrice: q.strike,
      expirationDate: expirationDate,
      optionKind: q.optionType,
      greeks: greeks,
    )
  }
}
