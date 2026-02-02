import Foundation
import CommonBroker
import TradierLib
import WrkstrmFoundation
import WrkstrmMain
import WrkstrmNetworking

extension CommonOrder {
  public init(_ o: Tradier.Order) {
    self.init(
      id: o.id,
      type: o.type,
      symbol: o.symbol,
      side: o.side,
      quantity: o.quantity,
      status: o.status,
      duration: o.duration,
      price: o.price,
      createDate: o.createDate,
      transactionDate: o.transactionDate,
    )
  }
}

public struct TradierOrdersService: CommonOrdersService, Sendable {
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType
  private let client: Tradier.CodableService

  public init(environment: HTTP.Environment) {
    client = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOrdersService.")
    }
  }

  /// Instrumented initializer allowing a custom JSON parser.
  public init(environment: HTTP.Environment, parser: JSON.Parser) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOrdersService.")
    }
  }

  public func openOrders(
    for accountId: String,
    date: Date?,
    start: Date?,
    end: Date?,
    page: Int?,
    limit: Int?,
  ) async throws -> [CommonOrder] {
    let request = Tradier.AccountOrdersRequest(
      accountId: accountId,
      filter: .intraday,
      page: page,
      limit: limit,
      date: date,
      start: start,
      end: end,
      includeTags: nil,
    )
    let root: Tradier.OrdersRoot = try await client.client.send(request)
    return root.orders.map(CommonOrder.init)
  }
}
