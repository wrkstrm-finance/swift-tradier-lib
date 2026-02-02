import Foundation
import CommonBroker
import TradierLib

enum TestDecodeHelper {
  static func decode<T: Decodable>(_ json: String, as _: T.Type) throws -> T {
    let data = Data(json.utf8)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: data)
  }

  static func makeTradierQuote(symbol: String, last: Double? = nil) throws -> Tradier.Quote {
    var fields: [String] = [
      "\"symbol\":\"\(symbol)\"",
      "\"description\":\"\(symbol)\"",
      "\"exch\":\"Q\"",
      "\"type\":\"stock\"",
      "\"volume\":0",
      "\"last_volume\":0",
      "\"trade_date\":1700000000",
      "\"bidsize\":1",
      "\"asksize\":1",
      "\"bid\":100.0",
      "\"ask\":101.0",
      "\"bid_date\":1700000000",
      "\"ask_date\":1700000100",
    ]
    if let last { fields.append("\"last\":\(last)") }
    let json = "{" + fields.joined(separator: ",") + "}"
    return try decode(json, as: Tradier.Quote.self)
  }

  static func makeTradierUserProfile(id: String, name: String) throws -> Tradier.UserProfile {
    let json = "{" + "\"accounts\":[],\"id\":\"\(id)\",\"name\":\"\(name)\"" + "}"
    return try decode(json, as: Tradier.UserProfile.self)
  }

  static func makeTradierAccountProfile(
    accountId: String, status: String? = nil, classification: String? = nil,
    accountName: String? = nil,
  ) throws -> Tradier.AccountProfile {
    var fields = ["\"account_number\":\"\(accountId)\""]
    if let status { fields.append("\"status\":\"\(status)\"") }
    if let classification { fields.append("\"classification\":\"\(classification)\"") }
    if let accountName {
      fields.append("\"name\":{\"first\":\"\(accountName)\",\"last\":\"\(accountName)\"}")
    }
    let json = "{" + fields.joined(separator: ",") + "}"
    return try decode(json, as: Tradier.AccountProfile.self)
  }

  static func makeTradierBalance(
    cashAvailable: Double? = nil, totalEquity: Double? = nil, maintenanceMargin: Double? = nil,
    buyingPower: Double? = nil,
  ) throws -> Tradier.Balance {
    var fields: [String] = []
    if let cashAvailable { fields.append("\"cash\":{\"cash_available\":\(cashAvailable)}") }
    if let totalEquity { fields.append("\"total_equity\":\(totalEquity)") }
    var marginFields: [String] = []
    if let maintenanceMargin { marginFields.append("\"maintenance_call\":\(maintenanceMargin)") }
    if let buyingPower { marginFields.append("\"stock_buying_power\":\(buyingPower)") }
    if !marginFields.isEmpty {
      fields.append("\"margin\":{\(marginFields.joined(separator: ","))}")
    }
    let json = "{" + fields.joined(separator: ",") + "}"
    return try decode(json, as: Tradier.Balance.self)
  }
}
