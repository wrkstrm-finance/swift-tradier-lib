import Foundation
import Testing
import WrkstrmFoundation
import WrkstrmNetworking

@testable import TradierLib

@Suite("Option Expirations")
struct OptionExpirationsTests {
  @Test
  func requestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.OptionExpirationsRequest(
      symbol: "AAPL",
      includeAllRoots: true,
      strikes: true,
      contractSize: 100,
      expirationType: "monthly",
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/options/expirations?contractSize=100&expirationType=monthly&includeAllRoots=true&strikes=true&symbol=AAPL",
    )
  }

  @Test
  func requestOmitsOptionalParameters() throws {
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let request = Tradier.OptionExpirationsRequest(symbol: "AAPL")
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/options/expirations?symbol=AAPL",
    )
  }

  @Test
  func decodesStrikesAndExpirationTypes() throws {
    let json: Data =
      """
      {
        "expirations": {
          "expiration": [
            {
              "date": "2024-01-19",
              "expiration_type": "monthly",
              "strikes": {
                "strike": [100.0, 110.0]
              }
            }
          ]
        }
      }
      """.data(using: .utf8)!
    let decoded: Tradier.OptionExpirationsRoot =
      try Tradier.decoder.decode(Tradier.OptionExpirationsRoot.self, from: json)
    let first: Option.Expiration = try #require(decoded.expirations.expiration.first)
    #expect(first.date == "2024-01-19")
    #expect(first.expirationType == "monthly")
    #expect(first.strikes == [100.0, 110.0])
  }
}
