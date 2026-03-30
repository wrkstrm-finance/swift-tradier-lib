import Foundation

#if canImport(CoreData)
import CoreData
import CommonLog

extension CodingUserInfoKey {
  // swiftlint:disable:next force_unwrapping
  static let managedObjectContext: CodingUserInfoKey = .init(
    rawValue: "managedObjectContext",
  )!
}

public enum Managed: Sendable {
  public struct QuotesRoot: Codable, Sendable {
    public let quotes: TradierBrokerageQuotesModel?
  }

  public struct TradierBrokerageMultiQuotesRootModel: Codable, Sendable {
    public let quotes: TradierBrokerageMultiQuotesModel?
  }

  public struct TradierBrokerageQuotesModel: Codable, Sendable {
    public let quote: TradierBrokerageQuoteModel?
  }

  public struct TradierBrokerageMultiQuotesModel: Codable, Sendable {
    public let quotes: [TradierBrokerageQuotesModel]?
  }

  @objc(TradierBrokerageQuoteModel)
  public class TradierBrokerageQuoteModel: NSManagedObject, Codable, @unchecked Sendable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TradierBrokerageQuoteModel> {
      NSFetchRequest<TradierBrokerageQuoteModel>(entityName: "TradierBrokerageQuoteModel")
    }

    enum CodingKeys: String, CodingKey {
      case ask
      case askDate = "ask_date"
      case askexch
      case asksize
      case averageVolume = "average_volume"
      case bid
      case bidsize
      case bidexch
      case bidDate = "bid_date"
      case changePercentage = "change_percentage"
      case exch
      case symbol
      case symbolDescription = "description"
      case type
      case last
      case change
      case volume
      case open
      case high
      case low
      case close
      case lastVolume = "last_volume"
      case tradeDate = "trade_date"
      case prevClose = "prevclose"
      case rootSymbols = "root_symbols"
      case week52High = "week_52_high"
      case week52Low = "week_52_low"
    }

    @NSManaged public var ask: Double

    @NSManaged public var askexch: String?

    @NSManaged public var asksize: Double

    @NSManaged public var askDate: Date?

    @NSManaged public var bid: Double

    @NSManaged public var bidDate: Date

    @NSManaged public var bidsize: Double

    @NSManaged public var bidexch: String?

    @NSManaged public var change: Double

    @NSManaged public var exch: String?

    @NSManaged public var type: String?

    @NSManaged public var last: Float

    @NSManaged public var volume: Int

    @NSManaged public var open: Float

    @NSManaged public var high: Float

    @NSManaged public var low: Float

    @NSManaged public var close: Float

    @NSManaged public var changePercentage: Double

    @NSManaged public var averageVolume: Double

    // This can be Double.nan.
    // Managed objects cannot have optional Double values.
    @NSManaged public var lastVolume: Double

    @NSManaged public var tradeDate: Int

    @NSManaged public var prevClose: Float

    @NSManaged public var symbol: String

    @NSManaged public var symbolDescription: String?

    @NSManaged public var rootSymbols: String?

    @NSManaged public var week52High: Double

    @NSManaged public var week52Low: Double

    // MARK: - Decodable

    public required convenience init(from decoder: Decoder) throws {
      guard
        let managedObjectContext =
          decoder.userInfo[CodingUserInfoKey.managedObjectContext]
          as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(
          forEntityName: "ManagedQuote",
          in: managedObjectContext,
        )
      else {
        throw DecodingError.dataCorrupted(
          .init(
            codingPath: decoder.codingPath,
            debugDescription: "Failed to decode TradierBrokerageQuoteModel: missing managedObjectContext or entity",
          ))
      }

      self.init(entity: entity, insertInto: managedObjectContext)

      let container = try decoder.container(keyedBy: CodingKeys.self)

      asksize = try container.decode(Double.self, forKey: .asksize)

      askexch = try container.decodeIfPresent(String.self, forKey: .askexch)

      askDate = try container.decodeIfPresent(Date.self, forKey: .askDate)

      bidsize = try container.decode(Double.self, forKey: .bidsize)

      bidexch = try? container.decodeIfPresent(String.self, forKey: .bidexch)

      bidDate = try container.decode(Date.self, forKey: .bidDate)

      exch = try container.decode(String.self, forKey: .exch)

      type = try container.decode(String.self, forKey: .type)

      last =
        try container.decodeIfPresent(Float.self, forKey: .last)
        ?? Float.leastNormalMagnitude

      change = try container.decode(Double.self, forKey: .change)

      volume = try container.decodeIfPresent(Int.self, forKey: .volume) ?? 0

      open =
        try container.decodeIfPresent(Float.self, forKey: .open)
        ?? Float.leastNormalMagnitude

      high =
        try container.decodeIfPresent(Float.self, forKey: .high)
        ?? Float.leastNormalMagnitude

      low =
        try container.decodeIfPresent(Float.self, forKey: .low)
        ?? Float.leastNormalMagnitude

      close =
        try container.decodeIfPresent(Float.self, forKey: .close)
        ?? Float.leastNormalMagnitude

      bid = try container.decode(Double.self, forKey: .bid)

      ask = try container.decode(Double.self, forKey: .ask)

      changePercentage = try container.decode(
        Double.self,
        forKey: .changePercentage,
      )

      averageVolume = try container.decode(Double.self, forKey: .averageVolume)

      lastVolume = try container.decodeIfPresent(Double.self, forKey: .lastVolume) ?? Double.nan

      tradeDate = try container.decode(Int.self, forKey: .tradeDate)

      prevClose =
        try container.decodeIfPresent(Float.self, forKey: .prevClose)
        ?? Float.leastNormalMagnitude

      rootSymbols = try container.decodeIfPresent(
        String.self,
        forKey: .rootSymbols,
      )

      symbol = try container.decode(String.self, forKey: .symbol)

      symbolDescription = try container.decodeIfPresent(
        String.self,
        forKey: .symbolDescription,
      )

      week52High = try container.decode(Double.self, forKey: .week52High)

      week52Low = try container.decode(Double.self, forKey: .week52Low)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(symbol, forKey: .symbol)

      try container.encode(symbolDescription, forKey: .symbolDescription)

      try container.encode(exch, forKey: .exch)

      try container.encode(type, forKey: .type)

      try container.encode(last, forKey: .last)

      try container.encode(change, forKey: .change)

      try container.encode(volume, forKey: .volume)

      try container.encode(open, forKey: .open)

      try container.encode(high, forKey: .high)

      try container.encode(low, forKey: .low)

      try container.encode(close, forKey: .close)

      try container.encode(bid, forKey: .bid)

      try container.encode(ask, forKey: .ask)

      try container.encode(changePercentage, forKey: .changePercentage)

      try container.encode(averageVolume, forKey: .averageVolume)

      try container.encode(lastVolume, forKey: .lastVolume)

      try container.encode(tradeDate, forKey: .tradeDate)

      try container.encode(prevClose, forKey: .prevClose)

      try container.encode(bidsize, forKey: .bidsize)

      try container.encode(bidexch, forKey: .bidexch)

      try container.encode(bidDate, forKey: .bidDate)

      try container.encode(asksize, forKey: .asksize)

      try container.encode(askexch, forKey: .askexch)

      try container.encode(askDate, forKey: .askDate)

      try container.encode(rootSymbols, forKey: .rootSymbols)

      try container.encode(week52High, forKey: .week52High)

      try container.encode(week52Low, forKey: .week52Low)
    }
  }
}
#endif
