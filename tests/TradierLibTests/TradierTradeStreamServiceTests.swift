import Foundation
import Testing

@testable import TradierLib

private actor Box<T> {
  var value: T?
  func set(_ newValue: T?) { value = newValue }
}

@Suite("TradierTradeStreamService")
struct TradierTradeStreamServiceTests {
  @Test
  func handleFillPostsNotificationAndJournals() async {
    let journalBox: Box<Tradier.Transaction> = .init()
    let notifyBox: Box<Tradier.Transaction> = .init()
    let service: TradierTradeStreamService = .init(
      accountId: "1",
      tradierToken: "t",
      notionToken: "n",
      notionDatabaseId: "d",
      journaler: { tx in await journalBox.set(tx) },
    )
    let observer: NSObjectProtocol = NotificationCenter.default.addObserver(
      forName: TradierTradeStreamService.notification,
      object: nil,
      queue: nil,
    ) { note in
      let tx = note.object as? Tradier.Transaction
      Task { await notifyBox.set(tx) }
    }
    let json = """
      {"type":"fill","transaction":{"id":1,"type":"trade","trade":{"symbol":"AAPL","quantity":1}}}
      """
    await service.handle(text: json)
    NotificationCenter.default.removeObserver(observer)
    try? await Task.sleep(nanoseconds: 1_000_000)
    let journaled: Tradier.Transaction? = await journalBox.value
    let notified: Tradier.Transaction? = await notifyBox.value
    #expect(journaled?.trade?.symbol == "AAPL")
    #expect(notified?.trade?.symbol == "AAPL")
  }
}
