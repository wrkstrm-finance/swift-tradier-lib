import Foundation
import CommonBroker
import TradierLib

extension CommonBrokerageQuoteModel {
  /// Adapter from Tradier SDK model to CommonBrokerageQuoteModel.
  public init(_ tradierQuote: Tradier.TradierBrokerageQuoteModel) {
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

    let greeks: CommonBrokerageQuoteGreeksModel?
    if let g = tradierQuote.greeks {
      greeks = CommonBrokerageQuoteGreeksModel(
        delta: g.delta,
        gamma: g.gamma,
        theta: g.theta,
        vega: g.vega,
        rho: g.rho,
        phi: g.phi,
        bidImpliedVolatility: g.bidIv,
        midImpliedVolatility: g.midIv,
        askImpliedVolatility: g.askIv,
        smvVol: g.smvVol,
        updatedAt: g.updatedAt,
      )
    } else {
      greeks = nil
    }

    self.init(
      id: tradierQuote.id,
      assetType: tradierQuote.type,
      tradeDate: tradeDate,
      symbol: tradierQuote.symbol,
      symbolDescription: tradierQuote.symbolDescription,
      exchange: tradierQuote.exch,
      last: tradierQuote.last,
      change: tradierQuote.change,
      changePercentage: tradierQuote.changePercentage,
      bid: tradierQuote.bid,
      bidSize: Int(tradierQuote.bidsize * 100),
      bidExchange: tradierQuote.bidexch,
      bidDate: bidDate,
      ask: tradierQuote.ask,
      askSize: Int(tradierQuote.asksize * 100),
      askExchange: tradierQuote.askexch,
      askDate: askDate,
      open: tradierQuote.open,
      high: tradierQuote.high,
      low: tradierQuote.low,
      close: tradierQuote.close,
      volume: Int(tradierQuote.volume),
      previousClose: tradierQuote.prevclose,
      fiftyTwoWeekHigh: tradierQuote.week52High,
      fiftyTwoWeekLow: tradierQuote.week52Low,
      averageVolume: Int(tradierQuote.averageVolume ?? 0),
      latestTradeVolume: Int(tradierQuote.lastVolume),
      rootSymbol: tradierQuote.rootSymbol,
      underlying: tradierQuote.underlying,
      strikePrice: tradierQuote.strike,
      openInterest: tradierQuote.openInterest,
      contractSize: tradierQuote.contractSize,
      expirationDate: expirationDate,
      expirationStyle: tradierQuote.expirationType,
      optionKind: tradierQuote.optionType,
      greeks: greeks,
    )
  }
}
