# TradierLib

Swift package wrapping the [Tradier Brokerage API](https://documentation.tradier.com/brokerage-api).
Provides account, trading, and market data models used across wrkstrm apps.

## Utilities

- `tradier-json-perf-cli` — benchmarks decoding throughput for canonical Tradier payload fixtures.
  Build with `swift build --product tradier-json-perf-cli` and run with
  `swift run tradier-json-perf-cli --dir <payload-dir>`.

## JSON key mapping: Do/Don’t

- Do map wire keys explicitly with `CodingKeys`.

```swift
struct Quote: Decodable {
  let lastVolume: Double
  enum CodingKeys: String, CodingKey { case lastVolume = "last_volume" }
}
```

- Don’t rely on `.convertFromSnakeCase` / `.convertToSnakeCase` strategies.

See: ../../../../swift-universal-foundation/Sources/SwiftUniversalFoundation/Documentation.docc/AvoidSnakeCaseKeyStrategies.md
