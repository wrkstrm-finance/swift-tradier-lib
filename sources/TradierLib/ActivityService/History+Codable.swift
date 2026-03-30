import Foundation
import SwiftUniversalMain

extension Tradier {
  public struct TradierBrokerageHistoryRootModel: Codable, Sendable {
    public let history: TradierBrokerageHistoryModel?
  }

  public struct TradierBrokerageHistoryModel: Codable, Sendable, Equatable, Hashable {
    public let event: [TradierBrokerageTransactionModel]?
  }

  public enum HistoryEventType: String, Sendable, Equatable, Hashable {
    case trade
    case ach
    case transfer
  }

  public struct TradierBrokerageTradeEventModel: Codable, Sendable, Equatable, Hashable {
    public let commission: Double?
    public let description: String?
    public let price: Double?
    public let quantity: Double?
    public let symbol: String?
    public let tradeType: String?
  }

  public struct TradierBrokerageACHEventModel: Codable, Sendable, Equatable, Hashable {
    public let description: String?
    public let quantity: Double?
  }

  public struct TradierBrokerageTransferEventModel: Codable, Sendable, Equatable, Hashable {
    public let description: String?
    public let quantity: Double?
  }

  public struct TradierBrokerageTransactionModel: Codable, Identifiable, Sendable, Equatable, Hashable {
    public let id: Int?
    public let date: Date?
    public let amount: Double?
    public let type: String?
    public var details: Details?

    public init(
      id: Int? = nil,
      date: Date? = nil,
      amount: Double? = nil,
      type: String? = nil,
      details: Details? = nil,
    ) {
      self.id = id
      self.date = date
      self.amount = amount
      self.type = type
      self.details = details
    }

    public var trade: TradierBrokerageTradeEventModel? {
      if case .trade(let event) = details { return event }
      return nil
    }

    public var ach: TradierBrokerageACHEventModel? {
      if case .ach(let event) = details { return event }
      return nil
    }

    public var transfer: TradierBrokerageTransferEventModel? {
      if case .transfer(let event) = details { return event }
      return nil
    }

    private enum CodingKeys: String, CodingKey {
      case id
      case date
      case amount
      case type
      case trade
      case ach
      case transfer
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decodeIfPresent(Int.self, forKey: .id)
      date = try container.decodeIfPresent(Date.self, forKey: .date)
      amount = try container.decodeIfPresent(Double.self, forKey: .amount)
      type = try container.decodeIfPresent(String.self, forKey: .type)

      switch type {
      case "trade":
        let value = try container.decodeIfPresent(TradierBrokerageTradeEventModel.self, forKey: .trade)
        details = value.map { .trade($0) }

      case "ach":
        let value = try container.decodeIfPresent(TradierBrokerageACHEventModel.self, forKey: .ach)
        details = value.map { .ach($0) }

      case "transfer":
        let value = try container.decodeIfPresent(TradierBrokerageTransferEventModel.self, forKey: .transfer)
        details = value.map { .transfer($0) }

      default:
        details = .unknown
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encodeIfPresent(id, forKey: .id)
      try container.encodeIfPresent(date, forKey: .date)
      try container.encodeIfPresent(amount, forKey: .amount)
      try container.encodeIfPresent(type, forKey: .type)

      switch details {
      case .trade(let value):
        try container.encode(value, forKey: .trade)

      case .ach(let value):
        try container.encode(value, forKey: .ach)

      case .transfer(let value):
        try container.encode(value, forKey: .transfer)

      case .unknown, .none:
        break
      }
    }

    public enum Details: Codable, Sendable, Equatable, Hashable {
      case trade(TradierBrokerageTradeEventModel)
      case ach(TradierBrokerageACHEventModel)
      case transfer(TradierBrokerageTransferEventModel)
      case unknown

      public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let trade = try? container.decode(TradierBrokerageTradeEventModel.self) {
          self = .trade(trade)
        } else if let ach = try? container.decode(TradierBrokerageACHEventModel.self) {
          self = .ach(ach)
        } else if let transfer = try? container.decode(TradierBrokerageTransferEventModel.self) {
          self = .transfer(transfer)
        } else {
          self = .unknown
        }
      }

      public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .trade(let trade):
          try container.encode(trade)

        case .ach(let ach):
          try container.encode(ach)

        case .transfer(let transfer):
          try container.encode(transfer)

        case .unknown:
          break
        }
      }
    }
  }
}
