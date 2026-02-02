import CommonBroker
import TradierLib

extension CommonQuoteVariant {
  public init(_ tradierQuote: Tradier.Quote) {
    let full = CommonQuoteDetailed(CommonQuote(tradierQuote))
    self = .full(full)
  }
}
