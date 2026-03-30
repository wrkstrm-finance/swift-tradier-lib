// Overview: TradierBrokerageWatchlistModel CRUD methods for Tradier.CodableService.
// Maps to Tradier watchlists endpoints and models.
// Related: Watchlists+Codable.swift, CodableURLRequest+TradierBrokerageWatchlistModel.swift
import Foundation

extension Tradier.CodableService {
  public func watchlists() async throws -> [Tradier.TradierBrokerageWatchlistModel] {
    /// Lists all watchlists for the authenticated user.
    let request: Tradier.WatchlistsRequest = .init()
    let response: Tradier.TradierBrokerageWatchlistsRootModel = try await client.send(request)
    return response.watchlists.watchlist
  }

  public func watchlist(id: String) async throws -> Tradier.TradierBrokerageWatchlistModel {
    /// Retrieves a specific watchlist by id.
    let request: Tradier.WatchlistRequest = .init(watchlistId: id)
    let response: Tradier.TradierBrokerageWatchlistRootModel = try await client.send(request)
    return response.watchlist
  }

  public func createWatchlist(
    name: String,
    symbols: String?,
  ) async throws -> Tradier.TradierBrokerageWatchlistModel {
    /// Creates a new watchlist with an optional list of symbols.
    let request: Tradier.CreateWatchlistRequest = .init(
      name: name,
      symbols: symbols,
    )
    let response: Tradier.TradierBrokerageWatchlistRootModel = try await client.send(request)
    return response.watchlist
  }

  public func createWatchlist(
    name: String,
    symbols: [String] = [],
  ) async throws -> Tradier.TradierBrokerageWatchlistModel {
    let request: Tradier.CreateWatchlistRequest = .init(
      name: name,
      symbols: symbols,
    )
    let response: Tradier.TradierBrokerageWatchlistRootModel = try await client.send(request)
    return response.watchlist
  }

  public func add(
    symbols: [String],
    to watchlistId: String,
  ) async throws -> Tradier.TradierBrokerageWatchlistModel {
    /// Adds one or more symbols to the specified watchlist.
    let request: Tradier.AddSymbolsToWatchlistRequest = .init(
      watchlistId: watchlistId,
      symbols: symbols,
    )
    let response: Tradier.TradierBrokerageWatchlistRootModel = try await client.send(request)
    return response.watchlist
  }

  public func remove(symbol: String, from watchlistId: String) async throws -> Tradier.TradierBrokerageWatchlistModel {
    /// Removes a single symbol from the specified watchlist.
    let request: Tradier.RemoveSymbolFromWatchlistRequest = .init(
      watchlistId: watchlistId,
      symbol: symbol,
    )
    let response: Tradier.TradierBrokerageWatchlistRootModel = try await client.send(request)
    return response.watchlist
  }

  public func deleteWatchlist(id: String) async throws {
    /// Permanently deletes the specified watchlist.
    let request: Tradier.DeleteWatchlistRequest = .init(watchlistId: id)
    _ = try await client.send(request) as Tradier.TradierBrokerageWatchlistsRootModel
  }
}
