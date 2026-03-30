// Overview: Profile and balances requests.
// GET /user/profile, /accounts/{accountId}/profile, /balances
// Related: Profile+Codable.swift, Balances+Codable.swift
import Foundation
import CommonLog
import WrkstrmNetworking

extension Tradier {
  public struct UserProfileRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageUserProfileRootModel
    public var method: HTTP.Method { .get }
    public var path: String { "user/profile" }
    public var options: HTTP.Request.Options

    public init() {
      options = .init()
    }
  }

  public struct AccountProfileRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageProfileRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/profile" }
    public var options: HTTP.Request.Options

    public init(accountId: String) {
      self.accountId = accountId
      options = .init()
    }
  }

  public struct AccountBalancesRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageBalancesRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/balances" }
    public var options: HTTP.Request.Options

    public init(accountId: String) {
      self.accountId = accountId
      options = .init()
    }
  }
}
