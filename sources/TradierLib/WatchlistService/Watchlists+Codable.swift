import Foundation
import WrkstrmMain

extension Tradier {
  public struct WatchlistsRoot: Decodable, Sendable {
    public var watchlists: Watchlists

    public struct Watchlists: Decodable, Sendable {
      public var watchlist: [Watchlist]
    }
  }

  public struct WatchlistRoot: Decodable, Sendable {
    public var watchlist: Watchlist
  }

  public struct Watchlist: Decodable, Sendable, Identifiable {
    public var name: String
    public var id: String
    public var publicId: String
    public var items: Items?

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
        Items.self,
        forKey: .items,
      )
    }

    public struct Items: Decodable, Sendable {
      public var item: [Item]

      private enum CodingKeys: String, CodingKey { case item }

      public init(item: [Item]) {
        self.item = item
      }

      public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> =
          try decoder.container(keyedBy: CodingKeys.self)
        item =
          try container.decodeArrayAllowingNullOrSingle(
            Item.self,
            forKey: .item,
          ) ?? []
      }
    }

    public struct Item: Decodable, Sendable {
      public var symbol: String
      public var id: String
    }
  }
}
