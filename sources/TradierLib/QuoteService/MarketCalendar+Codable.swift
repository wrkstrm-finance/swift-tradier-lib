import Foundation

extension Tradier {
  public struct TradierBrokerageMarketCalendarRootModel: Decodable, Sendable {
    public var calendar: TradierBrokerageMarketCalendarModel

    public struct TradierBrokerageMarketCalendarModel: Decodable, Sendable {
      public var month: Int
      public var year: Int
      public var days: TradierBrokerageMarketCalendarDaysModel
    }

    public struct TradierBrokerageMarketCalendarDaysModel: Decodable, Sendable {
      public var day: [TradierBrokerageMarketCalendarDayModel]
    }

    public struct TradierBrokerageMarketCalendarDayModel: Decodable, Sendable {
      public var date: Date
      public var status: String
      public var description: String?
      public var premarket: TradierBrokerageMarketCalendarSessionModel?
      public var open: TradierBrokerageMarketCalendarSessionModel?
      public var postmarket: TradierBrokerageMarketCalendarSessionModel?

      private enum CodingKeys: String, CodingKey {
        case date, status, description, premarket, open, postmarket
      }

      public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .date)
        guard let parsedDate = TradierBrokerageMarketCalendarDayModel.dateFormatter.date(from: dateString) else {
          throw DecodingError.dataCorruptedError(
            forKey: .date, in: container,
            debugDescription: "Date string does not match format yyyy-MM-dd",
          )
        }
        date = parsedDate
        status = try container.decode(String.self, forKey: .status)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        if var premarket = try container.decodeIfPresent(
          TradierBrokerageMarketCalendarSessionModel.self,
          forKey: .premarket
        ) {
          premarket.start = TradierBrokerageMarketCalendarDayModel.combine(date: date, with: premarket.start)
          premarket.end = TradierBrokerageMarketCalendarDayModel.combine(date: date, with: premarket.end)
          self.premarket = premarket
        }
        if var open = try container.decodeIfPresent(
          TradierBrokerageMarketCalendarSessionModel.self,
          forKey: .open
        ) {
          open.start = TradierBrokerageMarketCalendarDayModel.combine(date: date, with: open.start)
          open.end = TradierBrokerageMarketCalendarDayModel.combine(date: date, with: open.end)
          self.open = open
        }
        if var postmarket = try container.decodeIfPresent(
          TradierBrokerageMarketCalendarSessionModel.self,
          forKey: .postmarket
        ) {
          postmarket.start = TradierBrokerageMarketCalendarDayModel.combine(date: date, with: postmarket.start)
          postmarket.end = TradierBrokerageMarketCalendarDayModel.combine(date: date, with: postmarket.end)
          self.postmarket = postmarket
        }
      }

      //      􀢄 Test decodesCalendar() recorded an issue at MarketCalendarTests.swift:64:5: Expectation failed: (session.start → 2020-03-31 18:30:00 +0000) == (expectedStart → 2019-03-31 16:30:00 +0000)
      //      􀢄 Test decodesCalendar() recorded an issue at MarketCalendarTests.swift:64:5: Expectation failed: (session.start → 2018-03-31 13:30:00 +0000) == (expectedStart → 2019-03-31 16:30:00 +0000)
      //      Expectation failed: (session.start → 0019-04-01 13:22:58 +0000) == (expectedStart → 2019-03-31 16:30:00 +0000)
      private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
      }()

      private static func combine(date: Date, with time: Date) -> Date {
        var utc = Calendar(identifier: .gregorian)
        utc.timeZone = TimeZone(secondsFromGMT: 0)!
        let parts = utc.dateComponents([.hour, .minute], from: time)
        var nyc = Calendar(identifier: .gregorian)
        nyc.timeZone = TradierBrokerageMarketCalendarDayModel.dateFormatter.timeZone
        return nyc.date(
          bySettingHour: parts.hour ?? 0,
          minute: parts.minute ?? 0,
          second: 0,
          of: date,
        )!
      }
    }

    public struct TradierBrokerageMarketCalendarSessionModel: Decodable, Sendable {
      public var start: Date
      public var end: Date

      private enum CodingKeys: String, CodingKey {
        case start, end
      }

      public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let startString = try container.decode(String.self, forKey: .start)
        let endString = try container.decode(String.self, forKey: .end)
        guard let startDate = TradierBrokerageMarketCalendarSessionModel.timeFormatter.date(from: startString) else {
          throw DecodingError.dataCorruptedError(
            forKey: .start, in: container,
            debugDescription: "Invalid time format for start: \(startString)",
          )
        }
        guard let endDate = TradierBrokerageMarketCalendarSessionModel.timeFormatter.date(from: endString) else {
          throw DecodingError.dataCorruptedError(
            forKey: .end, in: container,
            debugDescription: "Invalid time format for end: \(endString)",
          )
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let startComponents = calendar.dateComponents([.hour, .minute], from: startDate)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endDate)
        start = calendar.date(from: startComponents)!
        end = calendar.date(from: endComponents)!
      }

      private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
      }()
    }
  }
}
