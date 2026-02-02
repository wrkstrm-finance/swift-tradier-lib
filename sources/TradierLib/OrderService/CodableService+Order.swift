// Overview: Order placement for Tradier.CodableService.
// Creates equity/option orders via PlaceOrderRequest.
// Related: Orders+Codable.swift, CodableURLRequest+Trading.swift
import Foundation

extension Tradier.CodableService {
  /// Places an order for the specified account and symbol.
  /// - Parameters:
  ///   - accountId: Target account id.
  ///   - symbol: Ticker or OCC symbol.
  ///   - side: Buy or sell.
  ///   - quantity: Quantity to trade.
  ///   - type: Market or limit.
  ///   - duration: Order duration (e.g. day, gtc).
  ///   - price: Limit price (for limit orders).
  public func placeOrder(
    accountId: String,
    symbol: String,
    side: Tradier.PlaceOrderRequest.Side,
    quantity: Int,
    type: Tradier.PlaceOrderRequest.OrderType,
    duration: Tradier.PlaceOrderRequest.Duration,
    price: Double,
  ) async throws -> Tradier.OrderResult {
    let request = Tradier.PlaceOrderRequest(
      accountId: accountId,
      symbol: symbol,
      side: side,
      quantity: quantity,
      type: type,
      duration: duration,
      price: price,
    )
    let response = try await client.send(request)
    return response.order
  }

  /// Previews an order without executing it.
  /// Mirrors `placeOrder` parameters and returns an `OrderResult` with broker status.
  public func previewOrder(
    accountId: String,
    symbol: String,
    side: Tradier.PlaceOrderRequest.Side,
    quantity: Int,
    type: Tradier.PlaceOrderRequest.OrderType,
    duration: Tradier.PlaceOrderRequest.Duration,
    price: Double,
  ) async throws -> Tradier.OrderResult {
    let request = Tradier.PreviewOrderRequest(
      accountId: accountId,
      symbol: symbol,
      side: side,
      quantity: quantity,
      type: type,
      duration: duration,
      price: price,
    )
    let response = try await client.send(request)
    return response.order
  }
}
