import Foundation
import Testing

@testable import TradierLib

@Suite("Watchlists")
struct WatchlistDecodingTests {
  @Test
  func decodesSingleItemWatchlist() throws {
    let json: Data = """
      {
        "watchlist": {
          "name": "default",
          "id": "default",
          "public_id": "public-v6jjgj05z",
          "items": {
            "item": {
              "symbol": "AAPL",
              "id": "aapl"
            }
          }
        }
      }
      """.data(using: .utf8)!
    let decoder: JSONDecoder = Tradier.decoder
    let root: Tradier.TradierBrokerageWatchlistRootModel =
      try decoder.decode(Tradier.TradierBrokerageWatchlistRootModel.self, from: json)
    #expect(root.watchlist.items?.item.count == 1)
    #expect(root.watchlist.items?.item.first?.symbol == "AAPL")
  }

  @Test
  func decodesMultipleItemWatchlist() throws {
    let json: Data = """
      {
        "watchlist": {
          "name": "default",
          "id": "default",
          "public_id": "public-v6jjgj05z",
          "items": {
            "item": [
              { "symbol": "AAPL", "id": "aapl" },
              { "symbol": "AMZN", "id": "amzn" }
            ]
          }
        }
      }
      """.data(using: .utf8)!
    let decoder: JSONDecoder = Tradier.decoder
    let root: Tradier.TradierBrokerageWatchlistRootModel =
      try decoder.decode(Tradier.TradierBrokerageWatchlistRootModel.self, from: json)
    #expect(root.watchlist.items?.item.count == 2)
  }
}
