import Foundation
import CommonBroker
import Testing
import WrkstrmNetworking

@testable import TradierBrokerageCommonAdapters

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("TradierOrderServiceExtended")
struct TradierOrderServiceExtendedTests {
  @Test
  func preview_cancel_replace_status() async throws {
    // Inject a mock sender that decodes JSON into ResponseType generically.
    struct MockSender: TradierOrderRequestSending {
      func send<T>(_ request: T) async throws -> T.ResponseType where T: HTTP.CodableURLRequest {
        let path = request.path
        let body: Data
        if path.hasSuffix("/orders/preview") {
          body = TradierOrderServiceExtendedTests.orderResultJSON(
            id: 101, status: "preview", partnerId: "p1",
          )
        } else if path.contains("/orders/"), request.method == .put {
          body = TradierOrderServiceExtendedTests.orderResultWrapped(id: 102, status: "replaced")
        } else if path.contains("/orders/"), request.method == .delete {
          body = TradierOrderServiceExtendedTests.orderResultWrapped(id: 103, status: "canceled")
        } else if path.contains("/orders/"), request.method == .get {
          body = TradierOrderServiceExtendedTests.orderStatusWrapped(
            id: 104, symbol: "AAPL", status: "open",
          )
        } else {
          fatalError("Unexpected path: \(path)")
        }
        return try JSONDecoder().decode(T.ResponseType.self, from: body)
      }
    }

    let service = TradierOrderService(sender: MockSender())

    let preview = try await service.previewOrder(
      accountId: "VA000001",
      symbol: "AAPL",
      side: CommonOrderSide.buy,
      quantity: 1,
      type: CommonOrderType.limit,
      duration: CommonOrderDuration.day,
      price: 10,
    )
    #expect(preview.id == 101)
    #expect(preview.status == "preview")
    #expect(preview.partnerId == "p1")

    let replaced = try await service.replaceOrder(
      accountId: "VA000001", orderId: "999", quantity: 1, price: 10, stop: nil as Double?,
    )
    #expect(replaced.id == 102)
    #expect(replaced.status == "replaced")

    let canceled = try await service.cancelOrder(accountId: "VA000001", orderId: "777")
    #expect(canceled.id == 103)
    #expect(canceled.status == "canceled")

    let order = try await service.orderStatus(accountId: "VA000001", orderId: "888")
    #expect(order.id == 104)
    #expect(order.symbol == "AAPL")
    #expect(order.status == "open")
  }

  private static func orderResultJSON(id: Int, status: String, partnerId: String?) -> Data {
    let dict: [String: Any] = [
      "order": [
        "id": id,
        "status": status,
        "partnerId": partnerId as Any,
      ]
    ]
    return try! JSONSerialization.data(withJSONObject: dict)
  }

  private static func orderResultWrapped(id: Int, status: String) -> Data {
    orderResultJSON(id: id, status: status, partnerId: nil)
  }

  private static func orderStatusWrapped(id: Int, symbol: String, status: String) -> Data {
    let dict: [String: Any] = [
      "order": [
        "id": id,
        "type": "limit",
        "symbol": symbol,
        "side": "buy",
        "quantity": 1,
        "status": status,
        "duration": "day",
        "price": 10,
        "class": "equity",
      ] as [String: Any]
    ]
    return try! JSONSerialization.data(withJSONObject: dict)
  }
}
