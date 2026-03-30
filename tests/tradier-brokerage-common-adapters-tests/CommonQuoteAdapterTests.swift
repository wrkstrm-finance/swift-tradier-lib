import Testing
import CommonBroker
import TradierLib

@testable import TradierBrokerageCommonAdapters

@Test
func commonQuote_adapts_from_tradier_quote() throws {
  let symbol = "AAPL"
  let fields: [String] = [
    "\"description\":\"Apple Inc.\"",
    "\"symbol\":\"\(symbol)\"",
    "\"symbol_description\":\"Apple Inc.\"",
    "\"type\":\"stock\"",
    "\"exch\":\"Q\"",
    "\"last\":191.23",
    "\"change\":1.11",
    "\"change_percentage\":0.58",
    "\"bid\":191.20",
    "\"bidsize\":2",
    "\"bidexch\":\"Q\"",
    "\"trade_date\":1700000000",
    "\"bid_date\":1700000000",
    "\"ask\":191.25",
    "\"asksize\":3",
    "\"askexch\":\"Q\"",
    "\"ask_date\":1700000005",
    "\"open\":190.00",
    "\"high\":192.00",
    "\"low\":189.50",
    "\"close\":191.00",
    "\"volume\":12345678",
    "\"prevclose\":190.12",
    "\"week_52_high\":210.0",
    "\"week_52_low\":150.0",
    "\"average_volume\":90000000",
    "\"last_volume\":200",
  ]
  let json = "{" + fields.joined(separator: ",") + "}"
  let q: Tradier.TradierBrokerageQuoteModel = try TestDecodeHelper.decode(json, as: Tradier.TradierBrokerageQuoteModel.self)
  let cq = CommonBrokerageQuoteModel(q)

  #expect(cq.symbol == symbol)
  #expect(cq.symbolDescription == "Apple Inc.")
  #expect(cq.exchange == "Q")
  #expect(cq.last == 191.23)
  #expect(cq.change == 1.11)
  #expect(cq.changePercentage == 0.58)
  #expect(cq.bid == 191.20)
  #expect(cq.bidSize == 200)
  #expect(cq.ask == 191.25)
  #expect(cq.askSize == 300)
  #expect(cq.previousClose == 190.12)
  #expect(cq.fiftyTwoWeekHigh == 210.0)
  #expect(cq.fiftyTwoWeekLow == 150.0)
  #expect(cq.averageVolume == 90_000_000)
  #expect(cq.latestTradeVolume == 200)
  #expect(cq.bidDate != nil)
  #expect(cq.askDate != nil)
}
