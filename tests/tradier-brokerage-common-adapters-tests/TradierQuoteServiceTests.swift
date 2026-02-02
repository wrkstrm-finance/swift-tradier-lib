import Foundation
import CommonBroker
import Testing
import TradierLib

@testable import TradierBrokerageCommonAdapters

private struct TestError: Error {}

private actor MockTradierClient: TradierQuoteClient {
  nonisolated let serviceName: String = "Tradier(Mock)"
  var storageLast: [String: Double] = [:]
  func seed(symbol: String, last: Double) { storageLast[symbol] = last }
  func quote(for symbol: String) async throws -> Tradier.Quote {
    guard let last = storageLast[symbol] else { throw TestError() }
    return try TestDecodeHelper.makeTradierQuote(symbol: symbol, last: last)
  }

  func quotes(for symbols: [String]) async throws -> [Tradier.Quote] {
    var result: [Tradier.Quote] = []
    for symbol in symbols {
      try await result.append(quote(for: symbol))
    }
    return result
  }
}

@Test
func tradierQuoteService_maps_single_quote() async throws {
  let mock = MockTradierClient()
  await mock.seed(symbol: "AAPL", last: 100)

  #if DEBUG
  let sut = TradierSandboxQuoteService(client: mock)
  #else
  return  // Avoid constructing real service in non-DEBUG tests
  #endif
  let cq = try await sut.quote(for: "AAPL", accountId: "TEST")
  #expect(cq.last == 100)
}

@Test
func tradierQuoteService_maps_multiple_quotes() async throws {
  let mock = MockTradierClient()
  await mock.seed(symbol: "AAPL", last: 100)
  await mock.seed(symbol: "MSFT", last: 300)

  #if DEBUG
  let sut = TradierSandboxQuoteService(client: mock)
  #else
  return  // Avoid constructing real service in non-DEBUG tests
  #endif
  let cqs = try await sut.quotes(for: ["AAPL", "MSFT"], accountId: "TEST")
  #expect(cqs.count == 2)
  #expect(cqs[0].last == 100)
  #expect(cqs[1].last == 300)
}
