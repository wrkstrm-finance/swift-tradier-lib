import Foundation

extension Tradier {
  public struct ClockRoot: Decodable, Sendable {
    public var clock: Clock
  }

  public struct Clock: Decodable, Sendable {
    public var date: String
    public var description: String
    public var state: ClockState
    public var timestamp: Int
    public var nextChange: String
    public var nextState: ClockState

    private enum CodingKeys: String, CodingKey {
      case date, description, state, timestamp
      case nextChange = "next_change"
      case nextState = "next_state"
    }
  }

  public enum ClockState: String, Decodable, Sendable {
    case open
    case closed
    case premarket
    case postmarket
    case unknown

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let value = try container.decode(String.self)
      self = ClockState(rawValue: value) ?? .unknown
    }
  }
}
