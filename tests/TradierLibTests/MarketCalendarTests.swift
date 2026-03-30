import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

@Suite("Market Calendar")
struct MarketCalendarTests {
  @Test
  func requestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.MarketCalendarRequest(month: 2, year: 2019)
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/calendar?month=2&year=2019",
    )
  }

  @Test
  func decodesCalendar() throws {
    let json: Data =
      """
      {
        "calendar": {
          "month": 4,
          "year": 2019,
          "days": {
            "day": [
              {
                "date": "2019-04-01",
                "status": "open",
                "description": "Market is open",
                "premarket": { "start": "07:00", "end": "09:24" },
                "open": { "start": "09:30", "end": "16:00" },
                "postmarket": { "start": "16:00", "end": "20:00" }
              }
            ]
          }
        }
      }
      """.data(using: .utf8)!
    let decoded: Tradier.TradierBrokerageMarketCalendarRootModel =
      try Tradier.decoder.decode(Tradier.TradierBrokerageMarketCalendarRootModel.self, from: json)
    let first: Tradier.TradierBrokerageMarketCalendarRootModel.TradierBrokerageMarketCalendarDayModel =
      try #require(decoded.calendar.days.day.first)
    #expect(first.status == "open")
    let session = try #require(first.open)
    // Construct expected Date for 09:30 on the same day
    var calendar = Calendar(identifier: .gregorian)
    // The calendar returns a time based on from New York / Easter time.
    calendar.timeZone = TimeZone(identifier: "America/New_York")!
    var components = calendar.dateComponents([.year, .month, .day], from: first.date)
    components.hour = 9
    components.minute = 30
    let expectedStart = calendar.date(from: components)
    #expect(session.start == expectedStart)
  }
}
