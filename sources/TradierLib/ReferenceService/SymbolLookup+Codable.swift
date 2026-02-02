import Foundation

extension Tradier {
  public struct LookupRoot: Decodable, Sendable {
    public var securities: Securities?
  }

  public struct Securities: Decodable, Sendable {
    public var security: [Security]?
  }

  public struct Security: Decodable, Sendable, Hashable {
    public var symbol: String
    public var exchange: String?
    public var type: String?
    public var description: String

    private enum CodingKeys: String, CodingKey {
      case symbol, exchange, type, description
    }
  }
}
