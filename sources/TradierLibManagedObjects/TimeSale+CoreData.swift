#if canImport(CoreData)
import CoreData
import Foundation
import CommonLog

public class ManagedSeries: NSManagedObject, Codable {
  enum CodingKeys: String, CodingKey {
    case series
  }

  @NSManaged public var series: ManagedData

  // MARK: - Decodable

  public required convenience init(from decoder: Decoder) throws {
    guard
      let managedObjectContext =
        decoder.userInfo[CodingUserInfoKey.managedObjectContext]
        as? NSManagedObjectContext,
      let entity =
        NSEntityDescription.entity(forEntityName: "ManagedSeries", in: managedObjectContext)
    else { Log.guard("Failed to decode Series") }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    series = try container.decode(ManagedData.self, forKey: .series)
  }

  // MARK: - Encodable

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(series, forKey: .series)
  }
}

public class ManagedData: NSManagedObject, Codable {
  enum CodingKeys: String, CodingKey {
    case data
  }

  @NSManaged public var data: [ManagedTimeSale]

  // MARK: - Decodable

  public required convenience init(from decoder: Decoder) throws {
    guard
      let managedObjectContext =
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
      let entity =
        NSEntityDescription.entity(forEntityName: "ManagedData", in: managedObjectContext)
    else {
      Log.guard("Failed to decode ManagedData")
    }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    data = try container.decode([ManagedTimeSale].self, forKey: .data)
  }

  // MARK: - Encodable

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(data, forKey: .data)
  }
}

public class ManagedTimeSale: NSManagedObject, Comparable, Codable {
  public enum CodingKeys: String, CodingKey {
    case time

    case timestamp

    case price

    case open

    case high

    case low

    case close

    case volume

    case vwap

    //      case marketVolatility = "market_volatility"
  }

  public static func < (lhs: ManagedTimeSale, rhs: ManagedTimeSale) -> Bool {
    lhs.timestamp < rhs.timestamp
  }

  @NSManaged public var time: Date

  @NSManaged public var timestamp: Float

  @NSManaged public var price: Float

  @NSManaged public var open: Double

  @NSManaged public var high: Double

  @NSManaged public var low: Double

  @NSManaged public var close: Double

  @NSManaged public var volume: Double

  @NSManaged public var vwap: Double

  // public var marketVolatility: Data?

  public var min: Double { [open, high, low, close].min() ?? 0 }

  public var max: Double { [open, high, low, close].max() ?? 0 }

  // MARK: - Decodable

  public required convenience init(from decoder: Decoder) throws {
    guard
      let managedObjectContext =
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
      let entity =
        NSEntityDescription.entity(forEntityName: "ManagedTimeSale", in: managedObjectContext)
    else { Log.guard("Failed to decode TimeSale") }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    time = try container.decode(Date.self, forKey: .time)

    timestamp =
      try container.decodeIfPresent(Float.self, forKey: .timestamp)
      ?? Float.leastNormalMagnitude

    price =
      try container.decodeIfPresent(Float.self, forKey: .price)
      ?? Float.leastNormalMagnitude

    open = try container.decode(Double.self, forKey: .open)

    high = try container.decode(Double.self, forKey: .high)

    low = try container.decode(Double.self, forKey: .low)

    close = try container.decode(Double.self, forKey: .close)

    volume = try container.decode(Double.self, forKey: .volume)

    vwap = try container.decode(Double.self, forKey: .vwap)
  }

  // MARK: - Encodable

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(time, forKey: .time)

    try container.encode(timestamp, forKey: .timestamp)

    try container.encode(price, forKey: .price)

    try container.encode(open, forKey: .open)

    try container.encode(high, forKey: .high)

    try container.encode(low, forKey: .low)

    try container.encode(close, forKey: .close)

    try container.encode(volume, forKey: .volume)

    try container.encode(vwap, forKey: .vwap)
  }
}

public struct Leg: Decodable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case firstTime = "time"

    case lastTime = "last_time"

    case isUp = "up"

    case startInterval = "start_interval"

    case endTime = "end_time"

    case low

    case high

    case open

    case close

    case volume

    case numGen0 = "num_gen0"

    case totalOpenIntervals = "total_open_intervals"
  }

  public var firstTime: Date

  public var lastTime: Date

  public var isUp: UInt8

  public var startInterval: Float

  public var endTime: Date

  public var low: Float

  public var high: Float

  public var open: Float

  public var close: Float

  public var volume: Float

  public var numGen0: Int

  public var totalOpenIntervals: Float
}
#endif
