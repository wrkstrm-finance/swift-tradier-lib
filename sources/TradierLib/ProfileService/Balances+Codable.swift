import Foundation

extension Tradier {
  public struct BalancesRoot: Decodable, Sendable {
    public var balances: Balance
  }

  public struct Balance: Decodable, Sendable {
    public var accountNumber: String?
    public var accountType: String?
    public var totalCash: Double?
    public var totalEquity: Double?
    public var longMarketValue: Double?
    public var shortMarketValue: Double?
    public var closePl: Double?
    public var openPl: Double?
    public var pendingOrdersCount: Int?
    public var margin: MarginBalance?
    public var cash: CashBalance?

    private enum CodingKeys: String, CodingKey {
      case accountNumber = "account_number"
      case accountType = "account_type"
      case totalCash = "total_cash"
      case totalEquity = "total_equity"
      case longMarketValue = "long_market_value"
      case shortMarketValue = "short_market_value"
      case closePl = "close_pl"
      case openPl = "open_pl"
      case pendingOrdersCount = "pending_orders_count"
      case margin, cash
    }
  }

  public struct MarginBalance: Decodable, Sendable {
    public var fedCall: Double?
    public var maintenanceCall: Double?
    public var stockBuyingPower: Double?
    public var optionBuyingPower: Double?

    private enum CodingKeys: String, CodingKey {
      case fedCall = "fed_call"
      case maintenanceCall = "maintenance_call"
      case stockBuyingPower = "stock_buying_power"
      case optionBuyingPower = "option_buying_power"
    }
  }

  public struct CashBalance: Decodable, Sendable {
    public var cashAvailable: Double?
    public var unsettledFunds: Double?
    public var sweep: Double?

    private enum CodingKeys: String, CodingKey {
      case cashAvailable = "cash_available"
      case unsettledFunds = "unsettled_funds"
      case sweep
    }
  }
}
