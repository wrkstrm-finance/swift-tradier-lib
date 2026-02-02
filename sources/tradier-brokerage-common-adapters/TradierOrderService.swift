import Foundation
import CommonBroker
import TradierLib
import WrkstrmNetworking

public protocol TradierOrderRequestSending: Sendable {
  func send<T: HTTP.CodableURLRequest>(_ request: T) async throws -> T.ResponseType
}

extension HTTP.CodableClient: TradierOrderRequestSending {}

public struct TradierOrderService: CommonOrderService, Sendable {
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType
  private let sender: any TradierOrderRequestSending

  struct SvcSender: TradierOrderRequestSending {
    let service: Tradier.CodableService
    func send<T>(_ request: T) async throws -> T.ResponseType where T: HTTP.CodableURLRequest {
      try await service.client.send(request)
    }
  }

  public init(environment: HTTP.Environment) {
    let svc = Tradier.CodableService(environment: environment)
    sender = SvcSender(service: svc)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierOrderService.")
    }
  }

  #if DEBUG
  // Test-only initializer to inject a mock sender
  public init(sender: any TradierOrderRequestSending, serviceType: ServiceType = .sandbox) {
    self.sender = sender
    self.serviceType = serviceType
  }
  #endif

  public func placeOrder(
    accountId: String,
    symbol: String,
    side: CommonOrderSide,
    quantity: Int,
    type: CommonOrderType,
    duration: CommonOrderDuration,
    price: Double,
  ) async throws -> CommonOrderResult {
    let request = Tradier.PlaceOrderRequest(
      accountId: accountId,
      symbol: symbol,
      side: mapOrderSide(side),
      quantity: quantity,
      type: mapOrderType(type),
      duration: mapOrderDuration(duration),
      price: price,
    )
    let resp: Tradier.OrderResultRoot = try await sender.send(request)
    return CommonOrderResult(resp.order)
  }

  public func previewOrder(
    accountId: String,
    symbol: String,
    side: CommonOrderSide,
    quantity: Int,
    type: CommonOrderType,
    duration: CommonOrderDuration,
    price: Double,
  ) async throws -> CommonOrderResult {
    let request = Tradier.PreviewOrderRequest(
      accountId: accountId,
      symbol: symbol,
      side: mapOrderSide(side),
      quantity: quantity,
      type: mapOrderType(type),
      duration: mapOrderDuration(duration),
      price: price,
    )
    let resp: Tradier.OrderResultRoot = try await sender.send(request)
    return CommonOrderResult(resp.order)
  }

  public func replaceOrder(
    accountId: String,
    orderId: String,
    quantity: Int,
    price: Double,
    stop: Double?,
  ) async throws -> CommonOrderResult {
    let req = Tradier.ReplaceOrderRequest(
      accountId: accountId,
      orderId: orderId,
      quantity: quantity,
      price: price,
      stop: stop,
    )
    let resp: Tradier.OrderResultRoot = try await sender.send(req)
    return CommonOrderResult(resp.order)
  }

  public func cancelOrder(
    accountId: String,
    orderId: String,
  ) async throws -> CommonOrderResult {
    let req = Tradier.CancelOrderRequest(accountId: accountId, orderId: orderId)
    let resp: Tradier.OrderResultRoot = try await sender.send(req)
    return CommonOrderResult(resp.order)
  }

  public func orderStatus(accountId: String, orderId: String) async throws -> CommonOrder {
    let req = Tradier.AccountOrderRequest(accountId: accountId, orderId: orderId)
    let resp: Tradier.OrderRoot = try await sender.send(req)
    return CommonOrder(resp.order)
  }
}

private func mapOrderSide(_ side: CommonOrderSide) -> Tradier.PlaceOrderRequest.Side {
  Tradier.PlaceOrderRequest.Side(rawValue: side.rawValue) ?? .buy
}

private func mapOrderType(_ type: CommonOrderType) -> Tradier.PlaceOrderRequest.OrderType {
  Tradier.PlaceOrderRequest.OrderType(rawValue: type.rawValue) ?? .market
}

private func mapOrderDuration(_ duration: CommonOrderDuration) -> Tradier.PlaceOrderRequest.Duration {
  Tradier.PlaceOrderRequest.Duration(rawValue: duration.rawValue) ?? .day
}
