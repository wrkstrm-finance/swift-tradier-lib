import Foundation

extension Tradier {
  public struct TradierBrokerageUserProfileRootModel: Decodable, Sendable {
    public var profile: TradierBrokerageUserProfileModel
  }

  public struct TradierBrokerageUserProfileModel: Decodable, Sendable {
    public var accounts: [TradierBrokerageUserAccountModel]
    public var id: String?
    public var name: String?

    private enum CodingKeys: String, CodingKey {
      case accounts = "account"
      case id
      case name
    }

    public init(accounts: [TradierBrokerageUserAccountModel], id: String? = nil, name: String? = nil) {
      self.accounts = accounts
      self.id = id
      self.name = name
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      if let single = try? container.decode(TradierBrokerageUserAccountModel.self, forKey: .accounts) {
        accounts = [single]
      } else {
        accounts = try container.decodeIfPresent([TradierBrokerageUserAccountModel].self, forKey: .accounts) ?? []
      }
      id = try container.decodeIfPresent(String.self, forKey: .id)
      name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    /// Represents a user's brokerage account with Tradier, including account details and status.
    ///
    /// - Parameters:
    ///   - accountNumber: The unique identifier for the account.
    ///   - classification: The classification of the account (e.g., individual, joint).
    ///   - dateCreated: The date the account was created.
    ///   - dayTrader: Indicates if the account is marked as a day trader account.
    ///   - optionLevel: The approved options trading level for the account.
    ///   - status: The current status of the account (e.g., active, closed).
    ///   - type: The type of account (e.g., cash, margin).
    ///   - lastUpdateDate: The date the account was last updated.
    public struct TradierBrokerageUserAccountModel: Decodable, Sendable {
      /// The unique identifier for the account.
      public var accountNumber: String
      /// The classification of the account (e.g., individual, joint).
      public var classification: String?
      /// The date the account was created.
      public var dateCreated: Date?
      /// Indicates if the account is marked as a day trader account.
      public var dayTrader: Bool?
      /// The approved options trading level for the account.
      public var optionLevel: Int?
      /// The current status of the account (e.g., active, closed).
      public var status: String?
      /// The type of account (e.g., cash, margin).
      public var type: String?
      /// The date the account was last updated.
      public var lastUpdateDate: Date?

      private enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case classification
        case dateCreated = "date_created"
        case dayTrader = "day_trader"
        case optionLevel = "option_level"
        case status
        case type
        case lastUpdateDate = "last_updated"
      }
    }
  }
}
