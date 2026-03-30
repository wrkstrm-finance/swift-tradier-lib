import Foundation
import CommonBroker
import TradierLib

extension CommonBrokerageActivityEventModel {
  public init(_ tx: Tradier.TradierBrokerageTransactionModel) {
    let trade: CommonBrokerageTradeEventModel?
    if let t = tx.trade {
      trade = CommonBrokerageTradeEventModel(
        commission: t.commission,
        description: t.description,
        price: t.price,
        quantity: t.quantity,
        symbol: t.symbol,
        tradeType: t.tradeType,
      )
    } else {
      trade = nil
    }

    let ach: CommonBrokerageACHEventModel?
    if let a = tx.ach {
      ach = CommonBrokerageACHEventModel(description: a.description, quantity: a.quantity)
    } else {
      ach = nil
    }

    let transfer: CommonBrokerageTransferEventModel?
    if let tr = tx.transfer {
      transfer = CommonBrokerageTransferEventModel(description: tr.description, quantity: tr.quantity)
    } else {
      transfer = nil
    }

    self.init(
      id: tx.id,
      date: tx.date,
      type: tx.type,
      amount: tx.amount,
      trade: trade,
      ach: ach,
      transfer: transfer,
    )
  }
}
