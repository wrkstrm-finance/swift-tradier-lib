## TradierLib – API Coverage & Test Progress Report

- **Date:** 2025‑08‑27
- **Owner:** TradierLib Product Manager Agent
- **Repository:** wrkstrm/TradierLib

## Purpose

Provide a single source of truth for API surface coverage, test depth, and operational readiness across all Tradier capabilities. This document is designed to be kept in‑repo and updated per PR.

## How to Read

- Status keys: ✅ Implemented | 🟡 Partial | ⬜ Not Started | 🚫 N/A
- Tests: U = Unit, I = Integration (live sandbox), C = Contract (schema/fixtures), E2E = end‑to‑end smoke.
- Coverage % is reported via `swift test --enable-code-coverage` and parsed by `llvm-cov` in CI.

## CI Hooks

- Lint: swift-format, swiftlint
- Test matrix: macOS, Linux
- Coverage gate: fail if target < 70% lines, < 60% branches
- Doc gen: DocC bundle published on release
- SPM products: TradierLib, TradierStreaming, TradierTesting (mocks/fixtures)

## Implementation Status

### Authentication

| Capability             | Status | Notes                                                                                                                                | Tests |
| ---------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------ | ----- |
| Get Authorization Code | ⬜     | No OAuth helpers yet; Authorization Code + PKCE flow can be added with `ASWebAuthenticationSession` or a small CLI redirect handler. | —     |
| Create Access Token    | ⬜     | Token exchange request unimplemented; straightforward `URLSession` POST once auth code flow exists.                                  | —     |
| Refresh Access Token   | ⬜     | Refresh helpers not started; feasible via timer‑driven middleware and secure token storage.                                          | —     |

### Account Endpoints

| Endpoint        | Status | Data Model        | Tests | Observability                |
| --------------- | ------ | ----------------- | ----- | ---------------------------- |
| User Profile    | ✅     | `UserProfileRoot` | U     | —                            |
| Account Profile | ✅     | `ProfileRoot`     | U     | —                            |
| Balances        | ✅     | `BalancesRoot`    | U     | —                            |
| Positions       | ✅     | `PositionsRoot`   | U     | —                            |
| History         | ✅     | `HistoryRoot`     | U     | —                            |
| Gain/Loss       | 🟡     | `GainLossRoot`    | —     | Request exists but untested  |
| Orders          | ✅     | `OrdersRoot`      | U     | —                            |
| Order Detail    | ✅     | `OrderRoot`       | U     | Retry on 429, jitter         |
| Place Order     | 🟡     | `OrderResultRoot` | —     | Basic market/limit POST only |

### Trading Workflows

| Topic                                | Status | Notes                                           | Tests | Risk/Compliance |
| ------------------------------------ | ------ | ----------------------------------------------- | ----- | --------------- |
| Getting Started (route & validation) | ⬜     | No order builder or client‑side validation yet. | —     | —               |
| Preview Orders                       | ✅     | Preview request + URL test                      | U     | —               |
| Advanced Orders                      | ⬜     | OCO/OTOCO DAG modeling not started.             | —     | —               |
| Modify Order                         | 🟡     | Replace request exists; tests pending           | —     | —               |
| Cancel Order                         | 🟡     | Cancel request exists; tests pending            | —     | —               |
| Examples (Equity)                    | ⬜     | Sample builders absent.                         | —     | —               |
| Examples (Option)                    | ⬜     | —                                               | —     | —               |
| Examples (Multileg)                  | ⬜     | —                                               | —     | —               |
| Examples (Combo)                     | ⬜     | —                                               | —     | —               |
| Examples (OTO/OCO/OTOCO)             | ⬜     | —                                               | —     | —               |

### Market Data

| Endpoint                           | Status | Notes                                    | Tests | Performance             |
| ---------------------------------- | ------ | ---------------------------------------- | ----- | ----------------------- |
| Get Quotes (GET/POST)              | 🟡     | Request types exist; no unit tests yet.  | —     | Dedupe/coalesce planned |
| Get Option Chains                  | ✅     | Chain page + Greeks                      | U     | Pagination stream       |
| Get Option Strikes                 | ⬜     | Endpoint not wired.                      | —     | —                       |
| Get Option Expirations             | ✅     |                                          | U     | —                       |
| Lookup Option Symbols              | ⬜     | Parser not implemented.                  | —     | —                       |
| Get Historical Quotes              | ⬜     | No request layer.                        | —     | —                       |
| Get Time & Sales                   | 🟡     | `Series` model + request; tests missing. | —     | Throttle controls TBD   |
| Get ETB Securities                 | ⬜     |                                          | —     | —                       |
| Get Clock                          | ✅     |                                          | U     | —                       |
| Get Calendar                       | ✅     |                                          | U     | —                       |
| Search Companies                   | ⬜     | Not implemented.                         | —     | —                       |
| Lookup Symbol                      | ⬜     | Not implemented.                         | —     | —                       |
| Fundamentals (Company)             | ⬜     |                                          | —     | —                       |
| Fundamentals (Corporate Calendars) | ⬜     |                                          | —     | —                       |
| Fundamentals (Dividends)           | ⬜     |                                          | —     | —                       |
| Fundamentals (Corporate Actions)   | ⬜     |                                          | —     | —                       |
| Fundamentals (Ratios)              | ⬜     |                                          | —     | —                       |
| Fundamentals (Financial Reports)   | ⬜     |                                          | —     | —                       |
| Fundamentals (Price Statistics)    | ⬜     |                                          | —     | —                       |

### Streaming Channels

Real-time streams will drive a trading daemon that monitors position entry and exit against live prices.
| Channel | Status | Notes | Tests | Perf/Reliability |
| --- | --- | --- | --- | --- |
| HTTP Create Market Session | ⬜ | No session request. | — | — |
| HTTP Create Account Session | ⬜ | Not implemented. | — | — |
| HTTP Get Streaming Quotes | ⬜ | Streaming client absent. | — | — |
| WebSocket Market API | ⬜ | No WebSocket layer. | — | — |
| WebSocket Account API | ⬜ | — | — | — |

### Watchlist Endpoints

| Endpoint         | Status | Notes                         | Tests |
| ---------------- | ------ | ----------------------------- | ----- |
| Get Watchlists   | ✅     |                               | U     |
| Get a Watchlist  | ✅     |                               | U     |
| Create Watchlist | ✅     |                               | U     |
| Update Watchlist | ✅     |                               | U     |
| Delete Watchlist | ✅     |                               | U     |
| Add Symbols      | ✅     | Framework handles form‑encode | U     |
| Remove a Symbol  | ✅     |                               | U     |

### Reference Data

| Topic           | Status | Notes                       | Tests |
| --------------- | ------ | --------------------------- | ----- |
| Exchange Codes  | ✅     | Enum + decode safety        | U     |
| Responses (All) | 🟡     | JSON fixtures; schema tests | C     |

## Platform Layers

- Networking: async/await client, retry with exponential backoff and 429/5xx policies, idempotency tokens
- Auth: PKCE, token store, auto‑refresh middleware, secure keychain wrappers
- Models: Codable + Sendable, resilient decoders for nulls and number‑as‑string
- Persistence: GRDB optional sinks for quotes, chains, time‑and‑sales
- Caching: request coalescer for bursty UI, in‑memory LRU + SQLite disk cache
- Observability: CommonLog, metrics counters, structured error taxonomy
- Concurrency: TaskGroup fan‑out for batch endpoints; cooperative cancellation

## Risk, Finance, and Compliance

- Trading safeguards: client‑side checks for PDT, OCO/OTOCO atomicity, price band sanity
- Audit trail: persist order submits/modifies/cancels with timestamps and correlation IDs
- Lender optics: clean separation of market‑data vs trading scopes; rate‑limit governance
- Tax hygiene: realized P/L helper, wash‑sale hints, cost‑basis strategy toggle veneer
- Attribution: utility to satisfy vendor attribution guidelines in‑app

## Coverage Snapshot (auto‑filled by CI)

| Target           | Lines % | Branches % | Files | Last Run |
| ---------------- | ------- | ---------- | ----- | -------- |
| TradierLib       | —       | —          | —     | —        |
| TradierStreaming | —       | —          | —     | —        |
| TradierTesting   | —       | —          | —     | —        |

## Open Gaps & Next Steps

1. OAuth flow and token refresh – add Authorization Code + PKCE helpers and a simple keychain store. **Feasibility:** high; relies on `ASWebAuthenticationSession` or a CLI redirect URL.
2. Trading enhancements – build preview, modify, and cancel requests plus support for OCO/OTOCO structures. **Feasibility:** high; API surface is documented and mirrors existing `PlaceOrderRequest` patterns.
3. Historical quotes and time & sales persistence – extend GRDB layer and schedule background backfill jobs. **Feasibility:** moderate; requires pagination and disk usage tuning.
4. Streaming clients – implement HTTP session creation and `URLSessionWebSocketTask` wrappers with sequence‑gap repair. **Feasibility:** moderate; concurrency primitives already in use.
5. Fundamentals and symbol search endpoints – model company data, calendars, dividends, and lookup APIs. **Feasibility:** straightforward REST models.
6. Contract tests for all response models using frozen JSON fixtures. **Feasibility:** low effort once fixtures are curated.
7. CI niceties – publish DocC bundles, enforce coverage gates, and generate changelog on release. **Feasibility:** achievable with existing GitHub Actions.
8. Trading daemon for entry/exit automation – wire streaming prices to position monitors that trigger trade entry and exit logic. **Priority:** high; depends on streaming clients and order mutation endpoints.

## Developer Ergonomics

- `OrderBuilder` DSL for spreads, calendars, iron condors, OCO/OTOCO DAGs
- Quote cache with 1‑second coalescing for bursty UI view loads
- Per‑symbol SQLite shards for chains/prints; export to Parquet for research

## Maintenance Rules

- No public API without tests
- Breaking changes require a deprecation shim and migration notes
- Every endpoint must log request IDs and rate‑limit headers

## Appendix – Commands

- Lint Markdown (config enforces 100-character lines):

  ```bash
  npx markdownlint-cli2 \
    tradier_lib_api_coverage_test_progress_report.md \
    --config ../../configs/linting/.markdownlint.jsonc
  ```

- Run tests with coverage: `swift test --enable-code-coverage`
- Export coverage: `xcrun llvm-cov export -format=text .build/debug/TradierLibPackageTests.xctest/Contents/MacOS/TradierLibPackageTests -instr-profile .build/debug/codecov/default.profdata > coverage.txt`
- Generate DocC: `xcodebuild docbuild -scheme TradierLib -destination 'platform=macOS'`
