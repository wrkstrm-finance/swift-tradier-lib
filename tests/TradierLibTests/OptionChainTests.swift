import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

@Suite("Option Chain")
struct OptionChainTests {
  @Test
  func requestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let request = Tradier.OptionChainRequest(
      symbol: "VXX",
      expiration: "2019-05-17",
      greeks: true,
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/options/chains?expiration=2019-05-17&greeks=true&symbol=VXX",
    )
  }

  @Test
  func decodesGreeks() throws {
    let json: Data =
      """
      {
        "options": {
          "option": [
            {
              "symbol": "VXX190517P00016000",
              "description": "VXX May 17 2019 $16.00 Put",
              "exch": "Z",
              "type": "option",
              "volume": 0,
              "bid": 0.0,
              "ask": 0.01,
              "underlying": "VXX",
              "strike": 16.0,
              "last_volume": 0,
              "trade_date": 0,
              "bidsize": 0,
              "bidexch": "J",
              "bid_date": 1557171657000,
              "asksize": 611,
              "askexch": "Z",
              "ask_date": 1557172096000,
              "open_interest": 10,
              "contract_size": 100,
              "expiration_date": "2019-05-17",
              "expiration_type": "standard",
              "option_type": "put",
              "root_symbol": "VXX",
              "greeks": {
                "delta": 1.0,
                "gamma": 1.95546E-10,
                "theta": -0.00204837,
                "vega": 3.54672E-9,
                "rho": 0.106077,
                "phi": -0.28801,
                "bid_iv": 0.0,
                "mid_iv": 0.0,
                "ask_iv": 0.0,
                "smv_vol": 0.380002,
                "updated_at": "2019-08-29 14:59:08"
              }
            }
          ]
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(Tradier.TradierBrokerageOptionChainRootModel.self, from: json)
    let option = try #require(decoded.options.option.first)
    let greeks = try #require(option.greeks)
    #expect(greeks.delta == 1.0)
    #expect(greeks.vega == 3.54672e-9)
  }
}
