import Foundation
import CommonBroker
import TradierLib

extension CommonActivityEvent {
  public init(_ tx: Tradier.Transaction) {
    let trade: CommonTradeEvent?
    if let t = tx.trade {
      trade = CommonTradeEvent(
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

    let ach: CommonACHEvent?
    if let a = tx.ach {
      ach = CommonACHEvent(description: a.description, quantity: a.quantity)
    } else {
      ach = nil
    }

    let transfer: CommonTransferEvent?
    if let tr = tx.transfer {
      transfer = CommonTransferEvent(description: tr.description, quantity: tr.quantity)
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
