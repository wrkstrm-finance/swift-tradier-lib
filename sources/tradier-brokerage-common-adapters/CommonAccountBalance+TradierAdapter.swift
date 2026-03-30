import Foundation
import CommonBroker
import TradierLib

extension CommonBrokerageAccountBalanceModel {
  public init(_ tradierBalance: Tradier.TradierBrokerageBalanceModel) {
    self.init(
      accountNumber: tradierBalance.accountNumber,
      accountType: tradierBalance.accountType,
      totalCash: tradierBalance.totalCash,
      totalEquity: tradierBalance.totalEquity,
      longMarketValue: tradierBalance.longMarketValue,
      shortMarketValue: tradierBalance.shortMarketValue,
      closedProfitLoss: tradierBalance.closePl,
      openProfitLoss: tradierBalance.openPl,
      pendingOrdersCount: tradierBalance.pendingOrdersCount,
      federalFundsCall: tradierBalance.margin?.fedCall,
      maintenanceRequirement: tradierBalance.margin?.maintenanceCall,
      stockBuyingPower: tradierBalance.margin?.stockBuyingPower,
      optionBuyingPower: tradierBalance.margin?.optionBuyingPower,
      cashAvailable: tradierBalance.cash?.cashAvailable,
      unsettledFunds: tradierBalance.cash?.unsettledFunds,
      sweep: tradierBalance.cash?.sweep,
    )
  }
}
