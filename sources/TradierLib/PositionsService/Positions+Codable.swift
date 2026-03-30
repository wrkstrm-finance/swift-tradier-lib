import Foundation
import SwiftUniversalMain

extension Tradier {
  public struct TradierBrokeragePositionsRootModel: Decodable, Sendable {
    public var positions: TradierBrokeragePositionsModel?

    private enum CodingKeys: String, CodingKey { case positions }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      positions = try? container.decodeAllowingNullOrEmptyObject(
        Tradier.TradierBrokeragePositionsModel.self,
        forKey: .positions,
      )
    }
  }

  public struct TradierBrokeragePositionsModel: Decodable, Sendable {
    public var position: [TradierBrokeragePositionModel]?

    private enum CodingKeys: String, CodingKey { case position }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      position = try container.decodeArrayAllowingNullOrSingle(
        Tradier.TradierBrokeragePositionModel.self,
        forKey: .position,
      )
    }
  }

  public struct TradierBrokeragePositionModel: Decodable, Hashable, Sendable {
    public var symbol: String
    public var quantity: Double
    public var costBasis: Double?
    public var side: String?
    public var marketValue: Double?
    public var id: Int?
    public var account: String?
    public var accountId: String?
    public var dateAcquired: Date?
    public var pricePaid: Double?
    public var expirationDate: Date?
    public var strike: Double?
    public var optionType: String?
    public var underlying: String?

    private enum CodingKeys: String, CodingKey {
      case symbol
      case quantity
      case costBasis = "cost_basis"
      case side
      case marketValue = "market_value"
      case id
      case account
      case accountId = "account_id"
      case dateAcquired = "date_acquired"
      case pricePaid = "price_paid"
      case expirationDate = "expiration_date"
      case strike
      case optionType = "option_type"
      case underlying
    }
  }
}
