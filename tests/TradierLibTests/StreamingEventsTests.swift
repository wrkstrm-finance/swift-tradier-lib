import Foundation
import Testing

@testable import TradierLib

@Suite("StreamingEvents")
struct StreamingEventsTests {
  @Test
  func handleSingleQuote() async {
    let client: TradierEventsClient = .init(config: .init())
    let json = """
      {"type":"quote","symbol":"AAPL"}
      """
    client.handle(text: json)
    var iterator: AsyncStream<TradierEvent>.AsyncIterator = client.events.makeAsyncIterator()
    let event: TradierEvent? = await iterator.next()
    switch event {
    case .quote(let quote):
      #expect(quote.symbol == "AAPL")

    default:
      #expect(false)
    }
    await client.close()
  }

  @Test
  func handleNDJSON() async {
    let client: TradierEventsClient = .init(config: .init())
    let json = """
      {"type":"quote","symbol":"AAPL"}
      {"type":"trade","symbol":"AAPL","price":"100"}
      """
    client.handle(text: json)
    var iterator: AsyncStream<TradierEvent>.AsyncIterator = client.events.makeAsyncIterator()
    let first: TradierEvent? = await iterator.next()
    let second: TradierEvent? = await iterator.next()
    switch first {
    case .quote(let quote):
      #expect(quote.symbol == "AAPL")

    default:
      #expect(false)
    }
    switch second {
    case .trade(let trade):
      #expect(trade.symbol == "AAPL")

    default:
      #expect(false)
    }
    await client.close()
  }

  @Test
  func handleUnknownEvent() async {
    let client: TradierEventsClient = .init(config: .init())
    let json = """
      {"type":"mystery"}
      """
    client.handle(text: json)
    var iterator: AsyncStream<TradierEvent>.AsyncIterator = client.events.makeAsyncIterator()
    let event: TradierEvent? = await iterator.next()
    switch event {
    case .unknown(let type, _):
      #expect(type == "mystery")

    default:
      #expect(false)
    }
    await client.close()
  }
}
