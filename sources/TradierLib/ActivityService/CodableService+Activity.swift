// Overview: Activity and gain/loss queries for Tradier.CodableService.
// Exposes account history and closed positions (gain/loss).
// Related: TradierBrokerageHistoryModel+Codable.swift, TradierBrokerageGainLossModel+Codable.swift, CodableURLRequest+Activity.swift
import Foundation

extension Tradier.CodableService {
  /// Returns account history entries (transactions/events) for a date range.
  public func accountHistory(
    for accountId: String,
    start: Date? = nil,
    end: Date? = nil,
    type: Tradier.HistoryEventType? = nil,
  ) async throws -> [Tradier.TradierBrokerageTransactionModel] {
    let request: Tradier.AccountHistoryRequest = .init(
      accountId: accountId,
      start: start,
      end: end,
      type: type,
    )
    let response = try await client.send(request)
    return response.history?.event ?? []
  }

  /// Convenience wrapper for `accountHistory(for:start:end:type:)`.
  public func importHistoricalTrades(
    for accountId: String,
    start: Date? = nil,
    end: Date? = nil,
    type: Tradier.HistoryEventType? = nil,
  ) async throws -> [Tradier.TradierBrokerageTransactionModel] {
    try await accountHistory(
      for: accountId,
      start: start,
      end: end,
      type: type,
    )
  }

  /// Returns closed positions (gain/loss) for the specified account.
  public func accountGainLoss(
    for accountId: String,
    page: Int? = nil,
    limit: Int? = nil,
    sortBy: Tradier.AccountGainLossRequest.SortBy? = nil,
    sort: Tradier.AccountGainLossRequest.SortDirection? = nil,
    start: Date? = nil,
    end: Date? = nil,
    symbol: String? = nil,
  ) async throws -> [Tradier.TradierBrokerageClosedPositionModel] {
    let request: Tradier.AccountGainLossRequest = .init(
      accountId: accountId,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sort: sort,
      start: start,
      end: end,
      symbol: symbol,
    )
    let response: Tradier.TradierBrokerageGainLossRootModel = try await client.send(request)
    return response.gainloss?.closedPosition ?? []
  }
}
