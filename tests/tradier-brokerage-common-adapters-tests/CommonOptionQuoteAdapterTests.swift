import Testing
import CommonBroker
import TradierLib

@testable import TradierBrokerageCommonAdapters

@Test
func commonOptionQuote_adapts_from_tradier_quote() throws {
  let symbol = "AAPL250117C00180000"
  var q: Tradier.Quote = try TestDecodeHelper.makeTradierQuote(symbol: symbol, last: 5.55)
  q.underlying = "AAPL"
  q.bid = 5.50
  q.ask = 5.60
  q.strike = 180.0
  q.expirationDate = "2025-01-17"
  q.optionType = "call"
  let cq = CommonOptionQuote(q)

  #expect(cq.symbol == symbol)
  #expect(cq.underlying == "AAPL")
  #expect(cq.last == 5.55)
  #expect(cq.bid == 5.50)
  #expect(cq.ask == 5.60)
  #expect(cq.strike == 180.0)
  #expect(cq.optionType == "call")
  #expect(cq.expirationDate != nil)
}
