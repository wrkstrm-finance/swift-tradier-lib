import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("Account Profile")
struct AccountProfileTests {
  @Test
  func requestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env: Tradier.HTTPSSandboxEnvironment = .init()
    let client: HTTP.CodableClient = .init(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request: Tradier.AccountProfileRequest = .init(accountId: "123")
    let urlRequest: URLRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/accounts/123/profile",
    )
  }

  @Test
  func decodesData() throws {
    let json: Data = """
      {
        "profile": {
          "account_number": "VA000000",
          "classification": "individual",
          "day_trader": false,
          "option_level": 2,
          "account_type": "cash",
          "last_updated": "2024-01-15T12:30:45",
          "status": "active",
          "name": { "first": "John", "last": "Doe" },
          "address": {
            "address1": "123 Street",
            "address2": "Suite 100",
            "city": "City",
            "state": "CA",
            "postal_code": "90001",
            "country": "USA"
          },
          "email": "john@example.com",
          "phone": "555-1234"
        }
      }
      """.data(using: .utf8)!
    let decoded: Tradier.ProfileRoot = try Tradier.decoder.decode(
      Tradier.ProfileRoot.self,
      from: json,
    )
    #expect(decoded.profile.accountNumber == "VA000000")
    #expect(decoded.profile.name?.first == "John")
    #expect(decoded.profile.address?.city == "City")
  }
}
