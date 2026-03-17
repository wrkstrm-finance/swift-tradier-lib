import Foundation
import Testing
import SwiftUniversalFoundation
import WrkstrmNetworking

@testable import TradierLib

@Suite("Tradier")
struct TradierTests {
  @Test
  func quotesRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.MultiQuotesRequest(symbols: ["AAPL"])
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/quotes?symbols=AAPL",
    )
  }

  @Test
  func quotesRequestIncludesGreeks() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.MultiQuotesRequest(symbols: ["AAPL"], greeks: true)
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/quotes?greeks=true&symbols=AAPL",
    )
  }

  @Test
  func clockRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing),
    )
    let request = Tradier.ClockRequest()
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/markets/clock",
    )
  }

  @Test
  func clockDecodesResponse() throws {
    let json = """
      {
        "clock": {
          "date": "2019-05-06",
          "description": "Market is open from 09:30 to 16:00",
          "state": "open",
          "timestamp": 1557156988,
          "next_change": "16:00",
          "next_state": "postmarket"
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(Tradier.ClockRoot.self, from: json)
    #expect(decoded.clock.state == .open)
    #expect(decoded.clock.nextState == .postmarket)
  }

  @Test
  func customDateDecoderParsesMultipleFormats() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(Tradier.customDateDecoder)

    let millisecondsData = Data("1700000000000".utf8)
    let millisecondsDate = try decoder.decode(Date.self, from: millisecondsData)
    #expect(Int(millisecondsDate.timeIntervalSince1970) == 1_700_000_000)

    let stringData = Data("\"2024-01-15T12:30:45\"".utf8)
    let stringDate = try decoder.decode(Date.self, from: stringData)
    let expectedFormatter = DateFormatter()
    expectedFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    expectedFormatter.calendar = .init(identifier: .iso8601)
    expectedFormatter.timeZone = .init(secondsFromGMT: 0)
    expectedFormatter.locale = .init(identifier: "en_US_POSIX")
    let expected = expectedFormatter.date(from: "2024-01-15T12:30:45")
    #expect(stringDate == expected)
  }

  @Test
  func accountHistoryRequestBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let start = Date(timeIntervalSince1970: 0)
    let end = Date(timeIntervalSince1970: 86400)
    let request = Tradier.AccountHistoryRequest(
      accountId: "123",
      start: start,
      end: end,
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/accounts/123/history?end=19700102&start=19700101",
    )
  }

  @Test
  func accountHistoryRequestWithTypeBuildsURL() throws {
    setenv("TRADIER_SANDBOX_API_KEY", "TOKEN", 1)
    let env = Tradier.HTTPSSandboxEnvironment()
    let client = HTTP.CodableClient(
      environment: env,
      json: (JSONEncoder.commonDateFormatting, JSONDecoder.commonDateParsing)
    )
    let start = Date(timeIntervalSince1970: 0)
    let end = Date(timeIntervalSince1970: 86400)
    let request = Tradier.AccountHistoryRequest(
      accountId: "123",
      start: start,
      end: end,
      type: .trade,
    )
    let urlRequest = try client.buildURLRequest(
      for: request,
      in: env,
      with: JSONEncoder.commonDateFormatting,
    )
    #expect(
      urlRequest.url?.absoluteString
        == "https://sandbox.tradier.com/v1/accounts/123/history?end=19700102&start=19700101&type=trade",
    )
  }

  @Test
  func accountHistoryDecodesMixedEvents() throws {
    let json = """
      {
        "history": {
          "event": [
            {
              "amount": -50,
              "date": "2025-08-19T00:00:00Z",
              "ach": {
                "description": "ACH DISBURSEMENT",
                "quantity": 0
              },
              "type": "ach"
            },
            {
              "amount": -2556.23,
              "date": "2025-08-04T00:00:00Z",
              "trade": {
                "commission": 0,
                "description": "PUT  GS     08/29/25   705",
                "price": 12.78,
                "quantity": 2,
                "symbol": "GS250829P00705000",
                "trade_type": "option"
              },
              "type": "trade"
            }
          ]
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(
      Tradier.HistoryRoot.self,
      from: json,
    )
    let events = decoded.history?.event
    #expect(events?.count == 2)
    #expect(events?.first?.ach?.description == "ACH DISBURSEMENT")
    #expect(events?.last?.trade?.symbol == "GS250829P00705000")
  }

  @Test
  func accountHistoryDecodesTransferEvent() throws {
    let json = """
      {
        "history": {
          "event": [
            {
              "amount": -10,
              "date": "2025-08-04T00:00:00Z",
              "transfer": {
                "description": "Aug Pro Subscription",
                "quantity": 0
              },
              "type": "transfer"
            }
          ]
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(
      Tradier.HistoryRoot.self,
      from: json,
    )
    let event = decoded.history?.event?.first
    #expect(event?.transfer?.description == "Aug Pro Subscription")
  }

  @Test
  func accountPositionsDecode() throws {
    let json = """
      {
        "positions": {
          "position": [
            {
              "symbol": "AAPL",
              "quantity": 10,
              "cost_basis": 1000.0,
              "side": "long",
              "market_value": 1500.0,
              "id": 1
            }
          ]
        }
      }
      """.data(using: .utf8)!
    let decoded = try Tradier.decoder.decode(Tradier.PositionsRoot.self, from: json)
    let positions = decoded.positions?.position
    #expect(positions?.count == 1)
    let position = positions?.first
    #expect(position?.symbol == "AAPL")
    #expect(position?.marketValue == 1500.0)
  }

  @Test
  func optionContractGeneratesSymbols() {
    let calendar = Calendar(identifier: .gregorian)

    struct Case {
      let root: String
      let expiration: Date
      let kind: Tradier.OptionKind
      let strike: Decimal
      let expected: String
    }

    let cases: [Case] = [
      Case(
        root: "AAPL",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 12, day: 20))!,
        kind: .call,
        strike: 200,
        expected: "AAPL241220C00200000",
      ),
      Case(
        root: "MSFT",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 12, day: 20))!,
        kind: .put,
        strike: 350.5,
        expected: "MSFT241220P00350500",
      ),
      Case(
        root: "AMZN",
        expiration: calendar.date(from: DateComponents(year: 2025, month: 1, day: 17))!,
        kind: .call,
        strike: 150,
        expected: "AMZN250117C00150000",
      ),
      Case(
        root: "NVDA",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 9, day: 20))!,
        kind: .put,
        strike: 450.75,
        expected: "NVDA240920P00450750",
      ),
      Case(
        root: "GOOGL",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 9, day: 15))!,
        kind: .call,
        strike: 120,
        expected: "GOOGL230915C00120000",
      ),
      Case(
        root: "META",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 3, day: 15))!,
        kind: .put,
        strike: 180.5,
        expected: "META240315P00180500",
      ),
      Case(
        root: "TSLA",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 7, day: 19))!,
        kind: .call,
        strike: 250,
        expected: "TSLA240719C00250000",
      ),
      Case(
        root: "JPM",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 6, day: 16))!,
        kind: .put,
        strike: 140,
        expected: "JPM230616P00140000",
      ),
      Case(
        root: "JNJ",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 1, day: 19))!,
        kind: .call,
        strike: 160,
        expected: "JNJ240119C00160000",
      ),
      Case(
        root: "V",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 12, day: 15))!,
        kind: .put,
        strike: 220.25,
        expected: "V231215P00220250",
      ),
      Case(
        root: "PG",
        expiration: calendar.date(from: DateComponents(year: 2025, month: 3, day: 21))!,
        kind: .call,
        strike: 150,
        expected: "PG250321C00150000",
      ),
      Case(
        root: "MA",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 10, day: 18))!,
        kind: .put,
        strike: 330,
        expected: "MA241018P00330000",
      ),
      Case(
        root: "HD",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 11, day: 17))!,
        kind: .call,
        strike: 280,
        expected: "HD231117C00280000",
      ),
      Case(
        root: "XOM",
        expiration: calendar.date(from: DateComponents(year: 2025, month: 9, day: 19))!,
        kind: .put,
        strike: 110.5,
        expected: "XOM250919P00110500",
      ),
      Case(
        root: "BAC",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 8, day: 18))!,
        kind: .call,
        strike: 40,
        expected: "BAC230818C00040000",
      ),
      Case(
        root: "PFE",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 4, day: 19))!,
        kind: .put,
        strike: 35,
        expected: "PFE240419P00035000",
      ),
      Case(
        root: "CSCO",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 5, day: 19))!,
        kind: .call,
        strike: 50,
        expected: "CSCO230519C00050000",
      ),
      Case(
        root: "T",
        expiration: calendar.date(from: DateComponents(year: 2024, month: 1, day: 19))!,
        kind: .put,
        strike: 30,
        expected: "T240119P00030000",
      ),
      Case(
        root: "NFLX",
        expiration: calendar.date(from: DateComponents(year: 2023, month: 10, day: 20))!,
        kind: .call,
        strike: 400,
        expected: "NFLX231020C00400000",
      ),
      Case(
        root: "DIS",
        expiration: calendar.date(from: DateComponents(year: 2025, month: 6, day: 20))!,
        kind: .put,
        strike: 100,
        expected: "DIS250620P00100000",
      ),
    ]

    for c in cases {
      let generated = Tradier.optionContract(
        root: c.root,
        expiration: c.expiration,
        kind: c.kind,
        strike: c.strike,
        calendar: calendar,
      )
      #expect(generated == c.expected)
    }
  }

  @Test
  func optionContractHandlesFractionalStrikes() {
    let calendar = Calendar(identifier: .gregorian)
    let expiration = calendar.date(from: DateComponents(year: 2024, month: 1, day: 19))!
    let root = "EURUSD"
    // Walk a full dollar in one-cent increments to verify proper thousandth scaling
    for step in 0..<100 {
      let strike = Decimal(step) / 100
      let expectedStrike = step * 10
      let expected = String(format: "%@240119C%08d", root, expectedStrike)
      let generated = Tradier.optionContract(
        root: root,
        expiration: expiration,
        kind: .call,
        strike: strike,
        calendar: calendar,
      )
      #expect(generated == expected)
    }
  }
}
