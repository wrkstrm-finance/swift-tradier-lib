import Foundation
import Testing

@testable import TradierLib

@Suite("TradierBrokeragePositionsModel decoding")
struct PositionsDecodingTests {
  @Test
  func decodesNullPositions() throws {
    let json: Data = """
      { "positions": "null" }
      """.data(using: .utf8)!
    let decoded: Tradier.TradierBrokeragePositionsRootModel =
      try Tradier.decoder.decode(Tradier.TradierBrokeragePositionsRootModel.self, from: json)
    #expect(decoded.positions == nil)
  }

  @Test
  func decodesSinglePosition() throws {
    let json: Data = """
      {
        "positions": {
          "position": {
            "symbol": "AAPL",
            "quantity": 1
          }
        }
      }
      """.data(using: .utf8)!
    let decoded: Tradier.TradierBrokeragePositionsRootModel =
      try Tradier.decoder.decode(Tradier.TradierBrokeragePositionsRootModel.self, from: json)
    #expect(decoded.positions?.position?.count == 1)
    #expect(decoded.positions?.position?.first?.symbol == "AAPL")
    #expect(decoded.positions?.position?.first?.quantity == 1)
  }
}
