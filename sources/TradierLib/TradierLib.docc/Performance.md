# Performance — JSON Decoding

This page documents the local micro-benchmarks comparing Foundation's `JSONDecoder` and a custom parser via `JSON.Parser` (backed by ReerJSON). It includes frame-window tests (144 Hz), aggregate statistics, and CSV export.

## What We Measure

- Per-op timing for 200 decodes of a given payload.
- Frame-window runs per frame at 144 Hz (~6.944 ms).
- Aggregate stats across 25 windows: mean, median, p95 (runs/frame).
- Multiple payloads:
  - ``user_profile`` (TradierBrokerageUserProfileRootModel)
  - ``positions`` (TradierBrokeragePositionsRootModel)
  - ``positions_large`` (100 positions)
  - ``option_expirations`` (TradierBrokerageOptionExpirationsRootModel)
  - ``quotes`` (TradierBrokerageSingleQuoteRootModel)
  - ``option_chain`` (TradierBrokerageOptionChainRootModel)

## How to Run

```bash
cd orgs/wrkstrm-finance/public/spm/universal/domain/finance/swift-tradier-lib
swift test -q
```

Results print to the console and a CSV is written under `/tmp`:

```
payload,engine,mean,median,p95
user_profile,foundation,668.76,698.00,771.00
user_profile,reerjson,436.48,426.00,489.00
positions,foundation,445.76,455.00,478.00
positions,reerjson,292.16,295.00,325.00
positions_large,foundation,22.08,22.00,23.00
positions_large,reerjson,19.64,19.00,22.00
option_expirations,foundation,1018.16,1019.00,1109.00
option_expirations,reerjson,494.00,488.00,542.00
quotes,foundation,499.24,502.00,517.00
quotes,reerjson,387.24,397.00,418.00
option_chain,foundation,83.88,84.00,89.00
option_chain,reerjson,73.52,74.00,78.00
Wrote CSV: /tmp/tradierlib_perf_<timestamp>.csv
```

Per-op and 144 Hz budget lines are also printed:

```
Foundation: 200 decodes in 0.00730s (40.0 µs/op)
ReerJSON:  200 decodes in 0.00549s (27.5 µs/op)
144Hz frame budget: Foundation runs/frame=176, ReerJSON runs/frame=241
```

Note: Numbers vary by machine and load; use trends and p95 over point values.

## Warm-up Effects

We also test ReerJSON before and after "many runs" of Foundation (2s) to observe any cache/frequency warm-up effects. Example:

```
ReerJSON per-op (ns): pre=102,909 post=82,449 Δ=19.9% (ops: pre=4859 post=6065)
```

## Using ReerJSON in Your App

Create a `JSON.Parser` backed by ReerJSON via the adapter, and thread it into your services:

```swift
import ReerJSONParserAdapter
import SwiftUniversalFoundation

let parser = ReerJSONParserAdapter.makeParser()
// PublicLib
let pub = PublicClient(authenticator: auth, parser: parser)
// TradierLib
let tradier = Tradier.CodableService(environment: Tradier.HTTPSSandboxEnvironment(), json: parser)
```
