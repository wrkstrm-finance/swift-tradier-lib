# `TradierLib`

Broker API client for market data, accounts, orders, watchlists, and streaming.

TradierLib provides a Swift-first interface for the Tradier Brokerage API. Use
`Tradier.CodableService` for REST operations and `TradierEventsClient` for
real-time market streaming.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:BuildAQuickClient>

### Market Data

- ``Tradier.CodableService``
- ``Tradier.Interval``
- ``Tradier.Quote``
- ``Tradier.Series``
- ``Tradier.TimeSale``
- ``Option``
- <doc:ExploreOptions>

### Watchlists

- ``Tradier.Watchlist``
- ``Tradier.WatchlistsRoot``

### Profiles & Balances

- ``Tradier.UserProfile``
- ``Tradier.AccountProfile``
- ``Tradier.Balance``

### Positions & Activity

- ``Tradier.Position``
- ``Tradier.Transaction``
- ``Tradier.ClosedPosition``
- <doc:ExploreAccountActivity>

### Orders

- ``Tradier.Order``
- ``Tradier.OrderResult``
- <doc:PlaceAndManageOrders>

### Streaming

- ``TradierEventsClient``
- ``TradierStreamOptions``
- ``TradierEvent``
- ``Quote``
- ``Trade``
- ``Summary``
- ``TimeSale``
- ``TradeX``

### Performance

- <doc:Performance>
