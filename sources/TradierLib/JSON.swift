import Foundation
import SwiftUniversalFoundation

extension Tradier {
  // MARK: - JSON Decoding

  public static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(Self.customDateDecoder)
    return decoder
  }()

  // Fallback: yyyy-MM-dd'T'HH:mm:ss (no TZ) -> treat as UTC, POSIX-safe
  private static let ymdHmsNoTZ: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    f.calendar = .init(identifier: .iso8601)
    f.timeZone = .init(secondsFromGMT: 0)
    f.locale = .init(identifier: "en_US_POSIX")
    return f
  }()

  public static func customDateDecoder(_ decoder: Decoder) throws -> Date {
    let container = try decoder.singleValueContainer()

    // 1) Numeric epoch (auto-detect ms vs s)
    if let number = try? container.decode(Double.self) {
      let seconds = number > 9_999_999_999 ? number / 1000.0 : number
      return Date(timeIntervalSince1970: seconds)
    }

    // 2) String formats
    let raw = try container.decode(String.self)

    // Preferred fast paths
    if let d = DateFormatter.iso8601WithMillis.date(from: raw) { return d }  // ...SSS'Z'
    if let d = DateFormatter.iso8601NoMillis.date(from: raw) { return d }  // ...'Z' or with TZ

    // Common fallbacks (thread-safe if not mutated after init)
    if let d = DateFormatter.iso8601Full.date(from: raw) { return d }  // yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ
    if let d = DateFormatter.iso8601WithoutMilliseconds.date(from: raw) {
      return d
    }  // yyyy-MM-dd'T'HH:mm:ssZZZZZ
    if let d = DateFormatter.iso8601Simple.date(from: raw) { return d }  // yyyy-MM-dd'T'HH:mm:ss'Z'

    // No-TZ variant (assume UTC)
    if let d = ymdHmsNoTZ.date(from: raw) { return d }  // yyyy-MM-dd'T'HH:mm:ss

    // Date-only
    if raw.count == 8, let d = DateFormatter.dateOnlyEncoder.date(from: raw) {
      return d
    }  // yyyyMMdd

    // Legacy compact (Tradier-style)
    if let d = DateFormatter.iso8601Compact.date(from: raw) { return d }  // yyyyMMdd'T'HHmmssZ

    // Fail with context
    let ctx = DecodingError.Context(
      codingPath: decoder.codingPath,
      debugDescription: "Error Parsing Date \(raw)",
    )
    throw DecodingError.valueNotFound(Date.self, ctx)
  }
}
