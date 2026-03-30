import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

@Suite("Account Orders")
struct AccountOrdersTests {
  @Test
  func listRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let date = Date(timeIntervalSince1970: 0)
    let request = Tradier.AccountOrdersRequest(
      accountId: "123",
      filter: .all,
      page: 3,
      limit: 100,
      date: date,
      includeTags: true,
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/accounts/123/orders?date=19700101&filter=all&includeTags=true&limit=100&page=3",
    )
  }

  @Test
  func orderRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.AccountOrderRequest(
      accountId: "123",
      orderId: "456",
      includeTags: true,
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/accounts/123/orders/456?includeTags=true",
    )
  }

  @Test
  func placeOrderRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.PlaceOrderRequest(
      accountId: "123",
      symbol: "SPY",
      side: .buy,
      quantity: 10,
      type: .market,
      duration: .day,
      price: 1,
      stop: 1,
      tag: "my-tag-example-1",
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    let expected =
      "https://sandbox.tradier.com/v1/accounts/123/orders"
      + "?class=equity&duration=day&price=1.0&quantity=10"
      + "&side=buy&stop=1.0&symbol=SPY&tag=my-tag-example-1&type=market"
    #expect(urlRequest.url?.absoluteString == expected)
    #expect(urlRequest.httpMethod == "POST")
  }

  @Test
  func replaceOrderRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.ReplaceOrderRequest(
      accountId: "123",
      orderId: "456",
      quantity: 10,
      price: 1,
      stop: 1,
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    let expected =
      "https://sandbox.tradier.com/v1/accounts/123/orders/456"
      + "?price=1.0&quantity=10&stop=1.0"
    #expect(urlRequest.url?.absoluteString == expected)
    #expect(urlRequest.httpMethod == "PUT")
  }

  @Test
  func previewOrderRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let request = Tradier.PreviewOrderRequest(
      accountId: "123",
      symbol: "SPY",
      side: .buy,
      quantity: 10,
      type: .limit,
      duration: .day,
      price: 1,
      stop: 1,
      tag: "my-tag-example-1",
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    let expectedQueryItems: Set<URLQueryItem> = [
      URLQueryItem(name: "class", value: "equity"),
      URLQueryItem(name: "duration", value: "day"),
      URLQueryItem(name: "price", value: "1.0"),
      URLQueryItem(name: "quantity", value: "10"),
      URLQueryItem(name: "side", value: "buy"),
      URLQueryItem(name: "stop", value: "1.0"),
      URLQueryItem(name: "symbol", value: "SPY"),
      URLQueryItem(name: "tag", value: "my-tag-example-1"),
      URLQueryItem(name: "type", value: "limit"),
    ]
    let actualURL = urlRequest.url!
    let actualComponents = URLComponents(url: actualURL, resolvingAgainstBaseURL: false)!
    #expect(actualComponents.scheme == "https")
    #expect(actualComponents.host == "sandbox.tradier.com")
    #expect(actualComponents.path == "/v1/accounts/123/orders/preview")
    let actualQueryItems = Set(actualComponents.queryItems ?? [])
    #expect(actualQueryItems == expectedQueryItems)
    #expect(urlRequest.httpMethod == "POST")
  }

  @Test
  func decodesOrders() throws {
    let json = """
      {
        "orders": {
          "order": [
            {
              "id": 228175,
              "type": "limit",
              "symbol": "AAPL",
              "side": "buy",
              "quantity": 50.0,
              "status": "expired",
              "duration": "pre",
              "price": 22.0,
              "avg_fill_price": 0.0,
              "exec_quantity": 0.0,
              "last_fill_price": 0.0,
              "last_fill_quantity": 0.0,
              "remaining_quantity": 0.0,
              "create_date": "2018-06-01T12:02:29.682Z",
              "transaction_date": "2018-06-01T12:30:02.385Z",
              "class": "equity"
            },
            {
              "id": 228749,
              "type": "market",
              "symbol": "SPY",
              "side": "buy_to_open",
              "quantity": 1.0,
              "status": "expired",
              "duration": "pre",
              "avg_fill_price": 0.0,
              "exec_quantity": 0.0,
              "last_fill_price": 0.0,
              "last_fill_quantity": 0.0,
              "remaining_quantity": 0.0,
              "create_date": "2018-06-06T20:16:17.342Z",
              "transaction_date": "2018-06-06T20:16:17.357Z",
              "class": "option",
              "option_symbol": "SPY180720C00274000"
            },
            {
              "id": 229063,
              "type": "debit",
              "symbol": "SPY",
              "side": "buy",
              "quantity": 1.0,
              "status": "canceled",
              "duration": "pre",
              "price": 42.0,
              "avg_fill_price": 0.0,
              "exec_quantity": 0.0,
              "last_fill_price": 0.0,
              "last_fill_quantity": 0.0,
              "remaining_quantity": 0.0,
              "create_date": "2018-06-12T21:13:36.076Z",
              "transaction_date": "2018-06-12T21:18:41.604Z",
              "class": "combo",
              "num_legs": 2,
              "strategy": "covered call",
              "leg": [
                {
                  "id": 229064,
                  "type": "debit",
                  "symbol": "SPY",
                  "side": "buy",
                  "quantity": 100.0,
                  "status": "canceled",
                  "duration": "pre",
                  "price": 42.0,
                  "avg_fill_price": 0.0,
                  "exec_quantity": 0.0,
                  "last_fill_price": 0.0,
                  "last_fill_quantity": 0.0,
                  "remaining_quantity": 0.0,
                  "create_date": "2018-06-12T21:13:36.076Z",
                  "transaction_date": "2018-06-12T21:18:41.587Z",
                  "class": "equity"
                },
                {
                  "id": 229065,
                  "type": "debit",
                  "symbol": "SPY",
                  "side": "sell_to_close",
                  "quantity": 1.0,
                  "status": "canceled",
                  "duration": "pre",
                  "price": 42.0,
                  "avg_fill_price": 0.0,
                  "exec_quantity": 0.0,
                  "last_fill_price": 0.0,
                  "last_fill_quantity": 0.0,
                  "remaining_quantity": 0.0,
                  "create_date": "2018-06-12T21:13:36.076Z",
                  "transaction_date": "2018-06-12T21:18:41.597Z",
                  "class": "option",
                  "option_symbol": "SPY180720C00274000"
                }
              ]
            },
            {
              "id": 229123,
              "type": "credit",
              "symbol": "SPY",
              "side": "buy",
              "quantity": 1.0,
              "status": "expired",
              "duration": "pre",
              "price": 0.8,
              "avg_fill_price": 0.0,
              "exec_quantity": 0.0,
              "last_fill_price": 0.0,
              "last_fill_quantity": 0.0,
              "remaining_quantity": 0.0,
              "create_date": "2018-06-13T16:54:39.812Z",
              "transaction_date": "2018-06-13T20:55:00.069Z",
              "class": "multileg",
              "num_legs": 4,
              "strategy": "condor",
              "leg": [
                {"id": 229124, "type": "credit", "symbol": "SPY", "side": "buy_to_open",
                 "quantity": 1.0, "status": "expired", "duration": "pre", "price": 0.8,
                 "avg_fill_price": 0.0, "exec_quantity": 0.0, "last_fill_price": 0.0,
                 "last_fill_quantity": 0.0, "remaining_quantity": 0.0,
                 "create_date": "2018-06-13T16:54:39.812Z",
                 "transaction_date": "2018-06-13T20:55:00.069Z",
                 "class": "option", "option_symbol": "SPY180720C00274000"},
                {"id": 229125, "type": "credit", "symbol": "SPY", "side": "sell_to_open",
                 "quantity": 1.0, "status": "expired", "duration": "pre", "price": 0.8,
                 "avg_fill_price": 0.0, "exec_quantity": 0.0, "last_fill_price": 0.0,
                 "last_fill_quantity": 0.0, "remaining_quantity": 0.0,
                 "create_date": "2018-06-13T16:54:39.812Z",
                 "transaction_date": "2018-06-13T20:55:00.069Z",
                 "class": "option", "option_symbol": "SPY180720C00275000"},
                {"id": 229126, "type": "credit", "symbol": "SPY", "side": "sell_to_open",
                 "quantity": 1.0, "status": "expired", "duration": "pre", "price": 0.8,
                 "avg_fill_price": 0.0, "exec_quantity": 0.0, "last_fill_price": 0.0,
                 "last_fill_quantity": 0.0, "remaining_quantity": 0.0,
                 "create_date": "2018-06-13T16:54:39.812Z",
                 "transaction_date": "2018-06-13T20:55:00.069Z",
                 "class": "option", "option_symbol": "SPY180720C00276000"},
                {"id": 229127, "type": "credit", "symbol": "SPY", "side": "buy_to_open",
                 "quantity": 1.0, "status": "expired", "duration": "pre", "price": 0.8,
                 "avg_fill_price": 0.0, "exec_quantity": 0.0, "last_fill_price": 0.0,
                 "last_fill_quantity": 0.0, "remaining_quantity": 0.0,
                 "create_date": "2018-06-13T16:54:39.812Z",
                 "transaction_date": "2018-06-13T20:55:00.069Z",
                 "class": "option", "option_symbol": "SPY180720C00277000"}
              ]
            }
          ]
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(
      Tradier.TradierBrokerageOrdersRootModel.self,
      from: json,
    )
    #expect(decoded.orders.count == 4)
    #expect(decoded.orders[2].legs?.count == 2)
    #expect(decoded.orders[2].legs?.first?.class == "equity")
  }

  @Test
  func decodesOrder() throws {
    let json = """
      {
        "order": {
          "id": 228176,
          "type": "market",
          "symbol": "AAPL",
          "side": "buy",
          "quantity": 50.0,
          "status": "filled",
          "duration": "pre",
          "avg_fill_price": 187.93,
          "exec_quantity": 50.0,
          "last_fill_price": 187.93,
          "last_fill_quantity": 50.0,
          "remaining_quantity": 0.0,
          "create_date": "2018-06-01T12:02:37.377Z",
          "transaction_date": "2018-06-01T13:45:13.340Z",
          "class": "equity"
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(
      Tradier.TradierBrokerageOrderRootModel.self,
      from: json,
    )
    #expect(decoded.order.id == 228_176)
    #expect(decoded.order.symbol == "AAPL")
    #expect(decoded.order.status == "filled")
  }

  @Test
  func decodesOrderResult() throws {
    let json = """
      {
        "order": {
          "id": 257459,
          "status": "ok",
          "partner_id": "c4998eb7-06e8-4820-a7ab-55d9760065fb"
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(
      Tradier.TradierBrokerageOrderResultRootModel.self,
      from: json,
    )
    #expect(decoded.order.id == 257_459)
    #expect(decoded.order.status == "ok")
  }
}
