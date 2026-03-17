import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

extension CommonMarketState {
  init(_ s: Tradier.ClockState) {
    switch s {
    case .open: self = .open
    case .closed: self = .closed
    case .premarket: self = .premarket
    case .postmarket: self = .postmarket
    case .unknown: self = .unknown
    }
  }
}

extension CommonMarketClock {
  init(_ c: Tradier.Clock) {
    self.init(
      date: c.date,
      description: c.description,
      state: .init(c.state),
      timestamp: c.timestamp,
      nextChange: c.nextChange,
      nextState: .init(c.nextState),
    )
  }
}

extension CommonMarketSession {
  init(_ s: Tradier.MarketCalendarRoot.Session) {
    self.init(start: s.start, end: s.end)
  }
}

extension CommonMarketDay {
  init(_ d: Tradier.MarketCalendarRoot.Day) {
    self.init(
      date: d.date,
      status: d.status,
      description: d.description,
      premarket: d.premarket.map(CommonMarketSession.init),
      open: d.open.map(CommonMarketSession.init),
      postmarket: d.postmarket.map(CommonMarketSession.init),
    )
  }
}

extension CommonTimeSale {
  init(_ t: Tradier.TimeSale) {
    self.init(
      time: t.time,
      timestamp: t.timestamp,
      price: t.price,
      open: t.open,
      high: t.high,
      low: t.low,
      close: t.close,
      volume: t.volume,
      vwap: t.vwap,
    )
  }
}

extension CommonInterval {
  var tradier: Tradier.Interval {
    switch self {
    case .tick: .tick
    case .oneMin: .oneMin
    case .fiveMin: .fiveMin
    }
  }
}

public struct TradierMarketService: CommonMarketService, Sendable {
  private let client: Tradier.CodableService
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType

  public init(environment: HTTP.Environment) {
    client = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierMarketService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(
    environment: HTTP.Environment,
    parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable
  ) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierMarketService.")
    }
  }

  public func clock() async throws -> CommonMarketClock {
    let c: Tradier.Clock = try await client.clock()
    return .init(c)
  }

  public func calendar(month: Int, year: Int) async throws -> [CommonMarketDay] {
    let days: [Tradier.MarketCalendarRoot.Day] = try await client.marketCalendar(
      month: month,
      year: year,
    )
    return days.map(CommonMarketDay.init)
  }

  public func timeSales(symbol: String, interval: CommonInterval) async throws -> [CommonTimeSale] {
    let sales: [Tradier.TimeSale] = try await client.timeSales(
      for: symbol, interval: interval.tradier,
    )
    return sales.map(CommonTimeSale.init)
  }
}
