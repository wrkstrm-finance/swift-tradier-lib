import CommonBroker
import TradierLib

extension CommonQuoteVariant {
  public init(_ tradierQuote: Tradier.TradierBrokerageQuoteModel) {
    let full = CommonBrokerageQuoteDetailedModel(CommonBrokerageQuoteModel(tradierQuote))
    self = .full(full)
  }
}
