import Foundation
import CommonBroker
import TradierLib
import WrkstrmFoundation
import WrkstrmMain
import WrkstrmNetworking

extension CommonWatchlistItem {
  public init(_ i: Tradier.Watchlist.Item) {
    self.init(
      id: i.id,
      symbol: i.symbol,
    )
  }
}

extension CommonWatchlist {
  public init(_ w: Tradier.Watchlist) {
    self.init(
      id: w.id,
      name: w.name,
      publicId: w.publicId,
      items: (w.items?.item ?? []).map(CommonWatchlistItem.init),
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

  /// Instrumented initializer allowing a custom JSON parser.
  public init(environment: HTTP.Environment, parser: JSON.Parser) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierWatchlistService.")
    }
  }

  public func watchlists() async throws -> [CommonWatchlist] {
    let response: Tradier.WatchlistsRoot = try await client.client.send(Tradier.WatchlistsRequest())
    return response.watchlists.watchlist.map(CommonWatchlist.init)
  }

  public func watchlist(id: String) async throws -> CommonWatchlist {
    let response: Tradier.WatchlistRoot = try await client.client.send(
      Tradier.WatchlistRequest(watchlistId: id))
    return CommonWatchlist(response.watchlist)
  }

  public func createWatchlist(name: String, symbols: [String]?) async throws -> CommonWatchlist {
    guard let symbols, !symbols.isEmpty else {
      let req: Tradier.CreateWatchlistRequest = .init(name: name, symbols: nil as String?)
      let resp: Tradier.WatchlistRoot = try await client.client.send(req)
      return CommonWatchlist(resp.watchlist)
    }
    let req: Tradier.CreateWatchlistRequest = .init(name: name, symbols: symbols)
    let resp: Tradier.WatchlistRoot = try await client.client.send(req)
    return CommonWatchlist(resp.watchlist)
  }

  public func add(symbols: [String], to watchlistId: String) async throws -> CommonWatchlist {
    let req: Tradier.AddSymbolsToWatchlistRequest = .init(
      watchlistId: watchlistId, symbols: symbols,
    )
    let resp: Tradier.WatchlistRoot = try await client.client.send(req)
    return CommonWatchlist(resp.watchlist)
  }

  public func remove(symbol: String, from watchlistId: String) async throws -> CommonWatchlist {
    let req: Tradier.RemoveSymbolFromWatchlistRequest = .init(
      watchlistId: watchlistId, symbol: symbol,
    )
    let resp: Tradier.WatchlistRoot = try await client.client.send(req)
    return CommonWatchlist(resp.watchlist)
  }

  public func deleteWatchlist(id: String) async throws {
    let req: Tradier.DeleteWatchlistRequest = .init(watchlistId: id)
    _ = try await client.client.send(req) as Tradier.WatchlistsRoot
  }
}
