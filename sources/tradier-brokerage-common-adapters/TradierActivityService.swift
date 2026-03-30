import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

public struct TradierActivityService: CommonActivityService, Sendable {
  private let client: Tradier.CodableService
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType

  public init(environment: HTTP.Environment) {
    client = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierPositionsService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(environment: HTTP.Environment, parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierPositionsService.")
    }
  }

  public func history(
    for accountId: String,
    start: Date? = nil,
    end: Date? = nil,
    type: CommonHistoryEventType? = nil,
  ) async throws -> [CommonBrokerageActivityEventModel] {
    let tradierType = type.flatMap { Tradier.HistoryEventType(rawValue: $0.rawValue) }
    let transactions: [Tradier.TradierBrokerageTransactionModel] = try await client.accountHistory(
      for: accountId,
      start: start,
      end: end,
      type: tradierType,
    )
    return transactions.map(CommonBrokerageActivityEventModel.init)
  }

  public func gainLoss(
    for accountId: String,
    page: Int? = nil,
    limit: Int? = nil,
    sortBy: CommonGainLossSortBy? = nil,
    sort: CommonSortDirection? = nil,
    start: Date? = nil,
    end: Date? = nil,
    symbol: String? = nil,
  ) async throws -> [CommonBrokerageClosedPositionModel] {
    let tradierSortBy = sortBy.flatMap { Tradier.AccountGainLossRequest.SortBy(rawValue: $0.rawValue) }
    let tradierSort = sort.flatMap { Tradier.AccountGainLossRequest.SortDirection(rawValue: $0.rawValue) }
    let closed: [Tradier.TradierBrokerageClosedPositionModel] = try await client.accountGainLoss(
      for: accountId,
      page: page,
      limit: limit,
      sortBy: tradierSortBy,
      sort: tradierSort,
      start: start,
      end: end,
      symbol: symbol,
    )
    return closed.map(CommonBrokerageClosedPositionModel.init)
  }
}
