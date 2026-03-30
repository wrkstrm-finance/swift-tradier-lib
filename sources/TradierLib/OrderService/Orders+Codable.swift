import Foundation
import SwiftUniversalMain

extension Tradier {
  public struct TradierBrokerageOrderResultRootModel: Decodable, Sendable {
    public var order: TradierBrokerageOrderResultModel
  }

  public struct TradierBrokerageOrderResultModel: Decodable, Sendable {
    public var id: Int
    public var status: String
    public var partnerId: String?

    private enum CodingKeys: String, CodingKey {
      case id
      case status
      case partnerId
    }
  }

  public struct TradierBrokerageOrdersRootModel: Decodable, Sendable {
    public var orders: [TradierBrokerageOrderModel]

    private enum CodingKeys: String, CodingKey {
      case orders
    }

    private enum OrdersCodingKeys: String, CodingKey {
      case order
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let ordersContainer = try container.nestedContainer(
        keyedBy: OrdersCodingKeys.self,
        forKey: .orders,
      )
      orders =
        try ordersContainer.decodeArrayAllowingNullOrSingle(
          TradierBrokerageOrderModel.self,
          forKey: .order,
        ) ?? []
    }
  }

  public struct TradierBrokerageOrderRootModel: Decodable, Sendable {
    public var order: TradierBrokerageOrderModel
  }

  public struct TradierBrokerageOrderModel: Decodable, Sendable, Identifiable {
    public var id: Int
    public var type: String
    public var symbol: String
    public var side: String
    public var quantity: Double
    public var status: String
    public var duration: String
    public var price: Double?
    public var avgFillPrice: Double?
    public var execQuantity: Double?
    public var lastFillPrice: Double?
    public var lastFillQuantity: Double?
    public var remainingQuantity: Double?
    public var createDate: Date?
    public var transactionDate: Date?
    public var `class`: String
    public var optionSymbol: String?
    public var numLegs: Int?
    public var strategy: String?
    public var legs: [TradierBrokerageOrderModel]?

    private enum CodingKeys: String, CodingKey {
      case id
      case type
      case symbol
      case side
      case quantity
      case status
      case duration
      case price
      case avgFillPrice
      case execQuantity
      case lastFillPrice
      case lastFillQuantity
      case remainingQuantity
      case createDate
      case transactionDate
      case `class`
      case optionSymbol = "option_symbol"
      case numLegs = "num_legs"
      case strategy
      case legs = "leg"
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(Int.self, forKey: .id)
      type = try container.decode(String.self, forKey: .type)
      symbol = try container.decode(String.self, forKey: .symbol)
      side = try container.decode(String.self, forKey: .side)
      quantity = try container.decode(Double.self, forKey: .quantity)
      status = try container.decode(String.self, forKey: .status)
      duration = try container.decode(String.self, forKey: .duration)
      price = try container.decodeIfPresent(Double.self, forKey: .price)
      avgFillPrice = try container.decodeIfPresent(Double.self, forKey: .avgFillPrice)
      execQuantity = try container.decodeIfPresent(Double.self, forKey: .execQuantity)
      lastFillPrice = try container.decodeIfPresent(Double.self, forKey: .lastFillPrice)
      lastFillQuantity = try container.decodeIfPresent(Double.self, forKey: .lastFillQuantity)
      remainingQuantity = try container.decodeIfPresent(Double.self, forKey: .remainingQuantity)
      createDate = try container.decodeIfPresent(Date.self, forKey: .createDate)
      transactionDate = try container.decodeIfPresent(Date.self, forKey: .transactionDate)
      `class` = try container.decode(String.self, forKey: .class)
      optionSymbol = try container.decodeIfPresent(String.self, forKey: .optionSymbol)
      numLegs = try container.decodeIfPresent(Int.self, forKey: .numLegs)
      strategy = try container.decodeIfPresent(String.self, forKey: .strategy)
      legs = try container.decodeIfPresent([TradierBrokerageOrderModel].self, forKey: .legs)
    }
  }
}
