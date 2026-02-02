import Foundation
import CommonBroker
import TradierLib

extension CommonAccountBalance {
  public init(_ tradierBalance: Tradier.Balance) {
    self.init(
      accountNumber: tradierBalance.accountNumber,
      accountType: tradierBalance.accountType,
      totalCash: tradierBalance.totalCash,
      totalEquity: tradierBalance.totalEquity,
      longMarketValue: tradierBalance.longMarketValue,
      shortMarketValue: tradierBalance.shortMarketValue,
      closePl: tradierBalance.closePl,
      openPl: tradierBalance.openPl,
      pendingOrdersCount: tradierBalance.pendingOrdersCount,
      fedCall: tradierBalance.margin?.fedCall,
      maintenanceCall: tradierBalance.margin?.maintenanceCall,
      stockBuyingPower: tradierBalance.margin?.stockBuyingPower,
      optionBuyingPower: tradierBalance.margin?.optionBuyingPower,
      cashAvailable: tradierBalance.cash?.cashAvailable,
      unsettledFunds: tradierBalance.cash?.unsettledFunds,
      sweep: tradierBalance.cash?.sweep,
    )
  }
}
