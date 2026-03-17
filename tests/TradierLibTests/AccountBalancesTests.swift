import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

@Suite("Account Balances")
struct AccountBalancesTests {
  @Test
  func requestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.AccountBalancesRequest(accountId: "123")
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/accounts/123/balances",
    )
  }

  @Test
  func decodesData() throws {
    let json = """
      {
        "balances": {
          "account_number": "VA000000",
          "total_cash": 1000.0,
          "total_equity": 2000.0,
          "cash": {
            "cash_available": 500.0,
            "unsettled_funds": 100.0
          }
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(Tradier.BalancesRoot.self, from: json)
    #expect(decoded.balances.totalCash == 1000.0)
    #expect(decoded.balances.cash?.cashAvailable == 500.0)
  }
}
