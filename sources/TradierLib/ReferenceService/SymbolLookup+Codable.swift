import Foundation

extension Tradier {
  public struct TradierBrokerageLookupRootModel: Decodable, Sendable {
    public var securities: TradierBrokerageSecuritiesModel?
  }

  public struct TradierBrokerageSecuritiesModel: Decodable, Sendable {
    public var security: [TradierBrokerageSecurityModel]?
  }

  public struct TradierBrokerageSecurityModel: Decodable, Sendable, Hashable {
    public var symbol: String
    public var exchange: String?
    public var type: String?
    public var description: String

    private enum CodingKeys: String, CodingKey {
      case symbol, exchange, type, description
    }
  }
}
