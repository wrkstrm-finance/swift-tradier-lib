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
- ``Tradier.TradierBrokerageQuoteModel``
- ``Tradier.TradierBrokerageTimeSeriesModel``
- ``Tradier.TradierBrokerageTimeSaleModel``
- ``Option``
- <doc:ExploreOptions>

### Watchlists

- ``Tradier.TradierBrokerageWatchlistModel``
- ``Tradier.TradierBrokerageWatchlistsRootModel``

### Profiles & Balances

- ``Tradier.TradierBrokerageUserProfileRootModel``
- ``Tradier.TradierBrokerageProfileRootModel``
- ``Tradier.TradierBrokerageBalancesRootModel``

### Positions & Activity

- ``Tradier.TradierBrokeragePositionModel``
- ``Tradier.TradierBrokerageTransactionModel``
- ``Tradier.TradierBrokerageClosedPositionModel``
- <doc:ExploreAccountActivity>

### Orders

- ``Tradier.TradierBrokerageOrderModel``
- ``Tradier.TradierBrokerageOrderResultModel``
- <doc:PlaceAndManageOrders>

### Streaming

- ``TradierEventsClient``
- ``TradierStreamOptions``
- ``TradierEvent``
- ``TradierBrokerageQuoteModel``
- ``TradierBrokerageTradeModel``
- ``TradierBrokerageSummaryModel``
- ``TradierBrokerageTimeSaleModel``
- ``TradierBrokerageTradeXModel``

### Performance

- <doc:Performance>
