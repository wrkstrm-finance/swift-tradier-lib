import Foundation
import Testing
import WrkstrmFoundation
import WrkstrmNetworking

@testable import TradierLib

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("User Profile")
struct UserProfileTests {
  @Test
  func requestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env: Tradier.HTTPSSandboxEnvironment = .init()
    let client: HTTP.CodableClient = .init(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let request: Tradier.UserProfileRequest = .init()
    let urlRequest: URLRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/user/profile",
    )
  }

  @Test
  func decodesData() throws {
    let json: Data = try Bundle.module.json(named: "user_profile_full")
    let decoded: Tradier.UserProfileRoot = try Tradier.decoder.decode(
      Tradier.UserProfileRoot.self,
      from: json,
    )
    #expect(decoded.profile.accounts.count == 2)
    #expect(decoded.profile.accounts.first?.accountNumber == "VA000001")
    #expect(decoded.profile.id == "id-gcostanza")
    #expect(decoded.profile.name == "George Costanza")
  }
}
