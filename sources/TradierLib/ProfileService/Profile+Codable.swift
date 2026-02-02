import Foundation

extension Tradier {
  public struct ProfileRoot: Decodable, Sendable {
    public var profile: AccountProfile
  }

  public struct AccountProfile: Decodable, Sendable {
    public var accountNumber: String?
    public var classification: String?
    public var dayTrader: Bool?
    public var optionLevel: Int?
    public var accountType: String?
    public var lastUpdated: Date?
    public var status: String?
    public var name: ProfileName?
    public var address: ProfileAddress?
    public var email: String?
    public var phone: String?

    private enum CodingKeys: String, CodingKey {
      case accountNumber = "account_number"
      case classification
      case dayTrader = "day_trader"
      case optionLevel = "option_level"
      case accountType = "account_type"
      case lastUpdated = "last_updated"
      case status, name, address, email, phone
    }
  }

  public struct ProfileName: Decodable, Sendable {
    public var first: String?
    public var last: String?
  }

  public struct ProfileAddress: Decodable, Sendable {
    public var address1: String?
    public var address2: String?
    public var city: String?
    public var state: String?
    public var postalCode: String?
    public var country: String?

    private enum CodingKeys: String, CodingKey {
      case address1, address2, city, state, country
      case postalCode = "postal_code"
    }
  }
}
