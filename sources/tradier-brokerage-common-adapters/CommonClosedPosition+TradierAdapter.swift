import Foundation
import CommonBroker
import TradierLib

extension CommonBrokerageClosedPositionModel {
  public init(_ cp: Tradier.TradierBrokerageClosedPositionModel) {
    self.init(
      symbol: cp.symbol,
      quantity: cp.quantity,
      realizedPnl: cp.gainLoss,
      openDate: cp.openDate,
      closeDate: cp.closeDate,
      cost: cp.cost,
      proceeds: cp.proceeds,
      gainLossPercentage: cp.gainLossPercent,
      term: cp.term,
    )
  }
}
