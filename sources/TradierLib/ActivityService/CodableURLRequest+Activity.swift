// Overview: Activity and gain/loss requests for accounts.
// GET /accounts/{accountId}/history and /gainloss
// Related: TradierBrokerageHistoryModel+Codable.swift, TradierBrokerageGainLossModel+Codable.swift
import Foundation
import CommonLog
import WrkstrmNetworking

extension Tradier {
  public struct AccountHistoryRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageHistoryRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/history" }
    public var options: HTTP.Request.Options

    public init(
      accountId: String,
      start: Date? = nil,
      end: Date? = nil,
      type: Tradier.HistoryEventType? = nil,
    ) {
      self.accountId = accountId
      options = .make { q in
        q.add("type", value: type?.rawValue)
        if let start { q.add("start", value: DateFormatter.dateOnlyEncoder.string(from: start)) }
        if let end { q.add("end", value: DateFormatter.dateOnlyEncoder.string(from: end)) }
      }
    }
  }

  public struct AccountGainLossRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageGainLossRootModel
    public var method: HTTP.Method { .get }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/gainloss" }
    public var options: HTTP.Request.Options

    public enum SortBy: String, Sendable {
      case openDate
      case closeDate
    }

    public enum SortDirection: String, Sendable {
      case asc
      case desc
    }

    public init(
      accountId: String,
      page: Int? = nil,
      limit: Int? = nil,
      sortBy: SortBy? = nil,
      sort: SortDirection? = nil,
      start: Date? = nil,
      end: Date? = nil,
      symbol: String? = nil,
    ) {
      self.accountId = accountId
      options = .make { q in
        q.add("page", value: page)
        q.add("limit", value: limit)
        q.add("sortBy", value: sortBy?.rawValue)
        q.add("sort", value: sort?.rawValue)
        if let start { q.add("start", value: DateFormatter.dateOnlyEncoder.string(from: start)) }
        if let end { q.add("end", value: DateFormatter.dateOnlyEncoder.string(from: end)) }
        q.add("symbol", value: symbol)
      }
    }
  }
}
