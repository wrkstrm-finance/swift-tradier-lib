import Foundation
import WrkstrmNetworking

extension Tradier {
  public struct PlaceOrderRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.OrderResultRoot
    public var method: HTTP.Method { .post }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/orders" }
    public var options: HTTP.Request.Options

    public enum Side: String, Sendable {
      case buy
      case sell
    }

    public enum OrderType: String, Sendable {
      case market
      case limit
    }

    public enum Duration: String, Sendable {
      case day
      case gtc
    }

    public enum AssetClass: String, Sendable {
      case equity
      case option
    }

    public init(
      accountId: String,
      symbol: String,
      side: Side,
      quantity: Int,
      type: OrderType,
      duration: Duration,
      assetClass: AssetClass = .equity,
      price: Double,
      stop: Double? = nil,
      tag: String? = nil,
    ) {
      self.accountId = accountId
      options = .make { q in
        q.add("class", value: assetClass)
        q.add("symbol", value: symbol)
        q.add("side", value: side)
        q.add("quantity", value: quantity)
        q.add("type", value: type)
        q.add("duration", value: duration)
        q.add("price", value: price)
        q.add("stop", value: stop)
        q.add("tag", value: tag)
      }
    }
  }

  public struct PreviewOrderRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.OrderResultRoot
    public var method: HTTP.Method { .post }
    public var accountId: String
    public var path: String { "accounts/\(accountId)/orders/preview" }
    public var options: HTTP.Request.Options

    public init(
      accountId: String,
      symbol: String,
      side: Tradier.PlaceOrderRequest.Side,
      quantity: Int,
      type: Tradier.PlaceOrderRequest.OrderType,
      duration: Tradier.PlaceOrderRequest.Duration,
      assetClass: Tradier.PlaceOrderRequest.AssetClass = .equity,
      price: Double,
      stop: Double? = nil,
      tag: String? = nil,
    ) {
      self.accountId = accountId
      options = .make { q in
        q.add("class", value: assetClass)
        q.add("symbol", value: symbol)
        q.add("side", value: side)
        q.add("quantity", value: quantity)
        q.add("type", value: type)
        q.add("duration", value: duration)
        q.add("price", value: price)
        q.add("stop", value: stop)
        q.add("tag", value: tag)
      }
    }
  }

  public struct ReplaceOrderRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.OrderResultRoot
    public var method: HTTP.Method { .put }
    public var accountId: String
    public var orderId: String
    public var path: String { "accounts/\(accountId)/orders/\(orderId)" }
    public var options: HTTP.Request.Options

    public init(
      accountId: String,
      orderId: String,
      quantity: Int,
      price: Double,
      stop: Double? = nil,
    ) {
      self.accountId = accountId
      self.orderId = orderId
      options = .make { q in
        q.add("quantity", value: quantity)
        q.add("price", value: price)
        q.add("stop", value: stop)
      }
    }
  }

  public struct CancelOrderRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.OrderResultRoot
    public var method: HTTP.Method { .delete }
    public var accountId: String
    public var orderId: String
    public var path: String { "accounts/\(accountId)/orders/\(orderId)" }
    public var options: HTTP.Request.Options

    public init(accountId: String, orderId: String) {
      self.accountId = accountId
      self.orderId = orderId
      options = .init()
    }
  }
}
