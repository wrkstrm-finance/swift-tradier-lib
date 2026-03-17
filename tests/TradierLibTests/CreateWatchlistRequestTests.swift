import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("Watchlists")
struct CreateWatchlistRequestTests {
  @Test
  func buildsQueryFromSymbolString() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env: Tradier.HTTPSSandboxEnvironment = .init()
    let client: HTTP.CodableClient = .init(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let request: Tradier.CreateWatchlistRequest = .init(
      name: "MyList",
      symbols: "AAPL TSLA,MSFT",
    )
    let urlRequest: URLRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/watchlists?name=MyList&symbols=AAPL,TSLA,MSFT",
    )
  }
}
