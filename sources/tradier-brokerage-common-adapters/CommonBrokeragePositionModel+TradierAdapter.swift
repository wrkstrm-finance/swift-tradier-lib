import Foundation
import CommonBroker
import TradierLib

extension CommonBrokeragePositionModel {
  public init(_ position: Tradier.TradierBrokeragePositionModel) {
    self.init(
      symbol: position.symbol,
      quantity: position.quantity,
      costBasis: position.costBasis,
      marketValue: position.marketValue,
      side: position.side,
      id: position.id,
      account: position.account,
      accountId: position.accountId,
      dateAcquired: position.dateAcquired,
      pricePaid: position.pricePaid,
      expirationDate: position.expirationDate,
      strikePrice: position.strike,
      optionKind: position.optionType,
      underlying: position.underlying,
    )
  }
}
