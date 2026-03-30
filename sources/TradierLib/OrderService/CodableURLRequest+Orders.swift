// Overview: Account order listing and detail requests.
// GET /accounts/{accountId}/orders and /orders/{id}.
// Related: Orders+Codable.swift
import Foundation
import CommonLog
import WrkstrmNetworking

extension Tradier {
  public struct AccountOrdersRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageOrdersRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/orders" }
    public var options: HTTP.Request.Options

    public enum Filter: String, Sendable {
      case intraday
      case all
    }

    public init(
      accountId: String,
      filter: Filter? = nil,
      page: Int? = nil,
      limit: Int? = nil,
      date: Date? = nil,
      start: Date? = nil,
      end: Date? = nil,
      includeTags: Bool? = nil,
    ) {
      self.accountId = accountId
      options = .make { q in
        q.add("filter", value: filter?.rawValue)
        q.add("page", value: page)
        q.add("limit", value: limit)
        if let date { q.add("date", value: DateFormatter.dateOnlyEncoder.string(from: date)) }
        if let start { q.add("start", value: DateFormatter.dateOnlyEncoder.string(from: start)) }
        if let end { q.add("end", value: DateFormatter.dateOnlyEncoder.string(from: end)) }
        q.add("includeTags", value: includeTags)
      }
    }
  }

  public struct AccountOrderRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageOrderRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var orderId: String
    public var path: String { "accounts/\(accountId)/orders/\(orderId)" }
    public var options: HTTP.Request.Options

    public init(accountId: String, orderId: String, includeTags: Bool? = nil) {
      self.accountId = accountId
      self.orderId = orderId
      options = .make { q in q.add("includeTags", value: includeTags) }
    }
  }
}
