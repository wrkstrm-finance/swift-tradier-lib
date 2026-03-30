import Foundation
import SwiftUniversalMain

extension Tradier {
  public struct TradierBrokerageWatchlistsRootModel: Decodable, Sendable {
    public var watchlists: TradierBrokerageWatchlistCollectionModel

    public struct TradierBrokerageWatchlistCollectionModel: Decodable, Sendable {
      public var watchlist: [TradierBrokerageWatchlistModel]
    }
  }

  public struct TradierBrokerageWatchlistRootModel: Decodable, Sendable {
    public var watchlist: TradierBrokerageWatchlistModel
  }

  public struct TradierBrokerageWatchlistModel: Decodable, Sendable, Identifiable {
    public var name: String
    public var id: String
    public var publicId: String
    public var items: TradierBrokerageWatchlistItemsModel?

    enum CodingKeys: String, CodingKey {
      case name
      case id
      case publicId = "public_id"
      case items
    }

    public init(from decoder: Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> =
        try decoder.container(keyedBy: CodingKeys.self)
      name = try container.decode(String.self, forKey: .name)
      id = try container.decode(String.self, forKey: .id)
      publicId = try container.decode(String.self, forKey: .publicId)
      items = try container.decodeAllowingNullOrEmptyObject(
        TradierBrokerageWatchlistItemsModel.self,
        forKey: .items,
      )
    }

    public struct TradierBrokerageWatchlistItemsModel: Decodable, Sendable {
      public var item: [TradierBrokerageWatchlistItemModel]

      private enum CodingKeys: String, CodingKey { case item }

      public init(item: [TradierBrokerageWatchlistItemModel]) {
        self.item = item
      }

      public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> =
          try decoder.container(keyedBy: CodingKeys.self)
        item =
          try container.decodeArrayAllowingNullOrSingle(
            TradierBrokerageWatchlistItemModel.self,
            forKey: .item,
          ) ?? []
      }
    }

    public struct TradierBrokerageWatchlistItemModel: Decodable, Sendable {
      public var symbol: String
      public var id: String
    }
  }
}
