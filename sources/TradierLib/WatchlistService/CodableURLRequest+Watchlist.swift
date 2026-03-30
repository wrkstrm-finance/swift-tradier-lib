import Foundation
import SwiftUniversalFoundation
import CommonLog
import WrkstrmNetworking

extension Tradier {
  public struct WatchlistsRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistsRootModel
    public var method: HTTP.Method { .get }
    public var path: String { "watchlists" }
    public var options: HTTP.Request.Options

    public init() {
      options = .init()
    }
  }

  public struct WatchlistRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistRootModel
    public var method: HTTP.Method { .get }
    public var watchlistId: String
    public var path: String { "watchlists/\(watchlistId)" }
    public var options: HTTP.Request.Options

    public init(watchlistId: String) {
      self.watchlistId = watchlistId
      options = .init()
    }
  }

  public struct CreateWatchlistRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistRootModel
    public var method: HTTP.Method { .post }
    public var path: String { "watchlists" }
    public var options: HTTP.Request.Options

    public init(name: String, symbols: [String] = []) {
      options = .make { q in
        q.add("name", value: name)
        q.addJoined("symbols", values: symbols)
      }
    }

    public init(name: String, symbols: String?) {
      let parsedSymbols =
        symbols?
        .components(
          separatedBy: CharacterSet(charactersIn: ", ").union(
            .whitespacesAndNewlines,
          ),
        )
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
      self.init(name: name, symbols: parsedSymbols ?? [])
    }
  }

  public struct UpdateWatchlistRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistRootModel
    public var method: HTTP.Method { .put }
    public var watchlistId: String
    public var path: String { "watchlists/\(watchlistId)" }
    public var options: HTTP.Request.Options

    public init(
      watchlistId: String,
      name: String,
      symbols: [String]? = nil,
    ) {
      self.watchlistId = watchlistId
      options = .make(headers: ["Content-Type": "application/x-www-form-urlencoded"]) { q in
        q.add("name", value: name)
        q.addJoined("symbols", values: symbols)
      }
    }
  }

  public struct DeleteWatchlistRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistsRootModel
    public var method: HTTP.Method { .delete }
    public var watchlistId: String
    public var path: String { "watchlists/\(watchlistId)" }
    public var options: HTTP.Request.Options

    public init(watchlistId: String) {
      self.watchlistId = watchlistId
      options = .init()
    }
  }

  public struct AddSymbolsToWatchlistRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistRootModel
    public var method: HTTP.Method { .post }
    public var watchlistId: String
    public var path: String { "watchlists/\(watchlistId)/symbols" }
    public var options: HTTP.Request.Options

    public init(watchlistId: String, symbols: [String]) {
      self.watchlistId = watchlistId
      options = .make(headers: ["Content-Type": "application/x-www-form-urlencoded"]) { q in
        q.addJoined("symbols", values: symbols)
      }
    }
  }

  public struct RemoveSymbolFromWatchlistRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.TradierBrokerageWatchlistRootModel
    public var method: HTTP.Method { .delete }
    public var watchlistId: String
    public var symbol: String
    public var path: String { "watchlists/\(watchlistId)/symbols/\(symbol)" }
    public var options: HTTP.Request.Options

    public init(watchlistId: String, symbol: String) {
      self.watchlistId = watchlistId
      self.symbol = symbol
      options = .init()
    }
  }
}
