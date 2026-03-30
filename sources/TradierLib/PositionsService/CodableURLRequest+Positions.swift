// Overview: TradierBrokeragePositionsModel request for accounts.
// GET /accounts/{accountId}/positions
// Related: TradierBrokeragePositionsModel+Codable.swift
import Foundation
import CommonLog
import WrkstrmNetworking

extension Tradier {
  public struct AccountPositionsRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokeragePositionsRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/positions" }
    public var options: HTTP.Request.Options

    public init(accountId: String) {
      self.accountId = accountId
      options = .init()
    }
  }
}
