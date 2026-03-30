import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

extension CommonBrokerageWatchlistItemModel {
  public init(_ i: Tradier.TradierBrokerageWatchlistModel.TradierBrokerageWatchlistItemModel) {
    self.init(
      id: i.id,
      symbol: i.symbol,
    )
  }
}

extension CommonBrokerageWatchlistModel {
  public init(_ w: Tradier.TradierBrokerageWatchlistModel) {
    self.init(
      id: w.id,
      name: w.name,
      publicId: w.publicId,
      items: (w.items?.item ?? []).map(CommonBrokerageWatchlistItemModel.init),
    )
  }
}

public struct TradierWatchlistService: CommonWatchlistService, Sendable {
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType
  private let client: Tradier.CodableService

  public init(environment: HTTP.Environment) {
    client = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierWatchlistService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(environment: HTTP.Environment, parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierWatchlistService.")
    }
  }

  public func watchlists() async throws -> [CommonBrokerageWatchlistModel] {
    let response: Tradier.TradierBrokerageWatchlistsRootModel = try await client.client.send(Tradier.WatchlistsRequest())
    return response.watchlists.watchlist.map(CommonBrokerageWatchlistModel.init)
  }

  public func watchlist(id: String) async throws -> CommonBrokerageWatchlistModel {
    let response: Tradier.TradierBrokerageWatchlistRootModel = try await client.client.send(
      Tradier.WatchlistRequest(watchlistId: id))
    return CommonBrokerageWatchlistModel(response.watchlist)
  }

  public func createWatchlist(name: String, symbols: [String]?) async throws -> CommonBrokerageWatchlistModel {
    guard let symbols, !symbols.isEmpty else {
      let req: Tradier.CreateWatchlistRequest = .init(name: name, symbols: nil as String?)
      let resp: Tradier.TradierBrokerageWatchlistRootModel = try await client.client.send(req)
      return CommonBrokerageWatchlistModel(resp.watchlist)
    }
    let req: Tradier.CreateWatchlistRequest = .init(name: name, symbols: symbols)
    let resp: Tradier.TradierBrokerageWatchlistRootModel = try await client.client.send(req)
    return CommonBrokerageWatchlistModel(resp.watchlist)
  }

  public func add(symbols: [String], to watchlistId: String) async throws -> CommonBrokerageWatchlistModel {
    let req: Tradier.AddSymbolsToWatchlistRequest = .init(
      watchlistId: watchlistId, symbols: symbols,
    )
    let resp: Tradier.TradierBrokerageWatchlistRootModel = try await client.client.send(req)
    return CommonBrokerageWatchlistModel(resp.watchlist)
  }

  public func remove(symbol: String, from watchlistId: String) async throws -> CommonBrokerageWatchlistModel {
    let req: Tradier.RemoveSymbolFromWatchlistRequest = .init(
      watchlistId: watchlistId, symbol: symbol,
    )
    let resp: Tradier.TradierBrokerageWatchlistRootModel = try await client.client.send(req)
    return CommonBrokerageWatchlistModel(resp.watchlist)
  }

  public func deleteWatchlist(id: String) async throws {
    let req: Tradier.DeleteWatchlistRequest = .init(watchlistId: id)
    _ = try await client.client.send(req) as Tradier.TradierBrokerageWatchlistsRootModel
  }
}
