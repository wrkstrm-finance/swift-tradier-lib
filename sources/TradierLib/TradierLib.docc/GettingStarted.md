# Getting Started

Kick the tires on market data and streaming with a few lines of Swift. These examples assume you’ve provisioned an API key and have a sandbox or production token configured.

## Quotes in 3 Lines

```swift
import TradierLib

// Defaults to sandbox; pass a production environment if needed.
let service = Tradier.CodableService()
let q = try await service.quote(for: "AAPL")
print("AAPL last: \(q.last ?? 0)")
```

Fetch multiple:

```swift
let quotes = try await service.quotes(for: ["AAPL", "MSFT", "NVDA"])
print(quotes.map(\.symbol))
```

## Option Expirations and a Few Strikes

```swift
let expirations = try await service.optionExpirations(for: "AAPL")
guard let first = expirations.first else { return }
let calls = try await service.optionQuotes(
  for: "AAPL", expiration: first, kind: .call, maxStrikes: 3, includeGreeks: true
)
print("first 3 calls: \(calls.count)")
```

## Watchlist CRUD

```swift
// Create a watchlist
let wl = try await service.createWatchlist(name: "Tech", symbols: ["AAPL", "MSFT"])

// Add/remove symbols
_ = try await service.add(symbols: ["NVDA"], to: wl.id)
_ = try await service.remove(symbol: "MSFT", from: wl.id)

// Fetch details
let fetched = try await service.watchlist(id: wl.id)
print("items: \(fetched.items?.item?.count ?? 0)")
```

## Profiles and Balances

```swift
let user = try await service.userProfile()
let accounts = user.accounts.account
let accountId = accounts.first?.accountNumber ?? ""

let profile = try await service.accountProfile(for: accountId)
let balances = try await service.accountBalances(for: accountId)
print(profile.account.accountStatus, balances.totalEquity)
```

## Place An Order (Requires Live Token + Approvals)

```swift
// Note: Only attempt in approved environments. Validate symbol, side, duration, etc.
let result = try await service.placeOrder(
  accountId: accountId,
  symbol: "AAPL",
  side: .buy, quantity: 1, type: .limit, duration: .day, price: 100.00
)
print("order id: \(result.id) status: \(result.status)")
```

## Stream Market Events

```swift
import TradierLib

// Obtain a session id from Tradier’s REST API, then stream symbols.
let client = TradierEventsClient(config: .init())
try await client.connect(
  sessionId: "<your-session-id>",
  symbols: ["AAPL", "MSFT"],
  filters: ["quote", "trade"],
  options: TradierStreamOptions(linebreak: true, validOnly: true)
)

for await event in client.events {
  switch event {
  case .quote(let q): print("quote: \(q.symbol) bid=\(q.bid ?? 0) ask=\(q.ask ?? 0)")
  case .trade(let t): print("trade: \(t.symbol) last=\(t.last ?? "?")")
  default: break
  }
}
```

## Notes

- Respect rate limits; prefer batch endpoints where available.
- Use sandbox for development; validate credentials and scopes before placing live orders.
- Consider wrapping calls in your own domain services for dependency injection and testing.
