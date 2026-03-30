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

extension CommonBrokerageMarketClockModel {
  init(_ c: Tradier.TradierBrokerageClockModel) {
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

extension CommonBrokerageMarketSessionModel {
  init(_ s: Tradier.TradierBrokerageMarketCalendarRootModel.TradierBrokerageMarketCalendarSessionModel) {
    self.init(start: s.start, end: s.end)
  }
}

extension CommonBrokerageMarketDayModel {
  init(_ d: Tradier.TradierBrokerageMarketCalendarRootModel.TradierBrokerageMarketCalendarDayModel) {
    self.init(
      date: d.date,
      status: d.status,
      description: d.description,
      premarket: d.premarket.map(CommonBrokerageMarketSessionModel.init),
      open: d.open.map(CommonBrokerageMarketSessionModel.init),
      postmarket: d.postmarket.map(CommonBrokerageMarketSessionModel.init),
    )
  }
}

extension CommonBrokerageTimeSaleModel {
  init(_ t: Tradier.TradierBrokerageTimeSaleModel) {
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

  public func clock() async throws -> CommonBrokerageMarketClockModel {
    let c: Tradier.TradierBrokerageClockModel = try await client.clock()
    return .init(c)
  }

  public func calendar(month: Int, year: Int) async throws -> [CommonBrokerageMarketDayModel] {
    let days: [Tradier.TradierBrokerageMarketCalendarRootModel.TradierBrokerageMarketCalendarDayModel] = try await client.marketCalendar(
      month: month,
      year: year,
    )
    return days.map(CommonBrokerageMarketDayModel.init)
  }

  public func timeSales(symbol: String, interval: CommonInterval) async throws -> [CommonBrokerageTimeSaleModel] {
    let sales: [Tradier.TradierBrokerageTimeSaleModel] = try await client.timeSales(
      for: symbol, interval: interval.tradier,
    )
    return sales.map(CommonBrokerageTimeSaleModel.init)
  }
}
