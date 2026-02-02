import Foundation
import CommonBroker
import TradierLib

extension CommonPosition {
  public init(_ position: Tradier.Position) {
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
      strike: position.strike,
      optionType: position.optionType,
      underlying: position.underlying,
    )
  }
}
