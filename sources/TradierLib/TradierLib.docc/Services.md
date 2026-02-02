# Services Overview

The primary entry point for REST operations is `Tradier.CodableService`. It exposes
per-domain methods for quotes, options, watchlists, profiles/balances, positions,
orders, and account activity.

## Topics

### Quotes & Options

- ``Tradier.CodableService/quote(for:)``
- ``Tradier.CodableService/quotes(for:)``
- ``Tradier.CodableService/timeSales(for:interval:)``
- ``Tradier.CodableService/optionExpirations(for:includeAllRoots:strikes:contractSize:expirationType:)``
- ``Tradier.CodableService/optionQuotes(for:expiration:kind:maxStrikes:includeGreeks:)``
- ``Tradier.CodableService/optionChain(for:expiration:includeGreeks:)``

### Watchlists

- ``Tradier.CodableService/watchlists()``
- ``Tradier.CodableService/watchlist(id:)``
- ``Tradier.CodableService/createWatchlist(name:symbols:)``
- ``Tradier.CodableService/add(symbols:to:)``
- ``Tradier.CodableService/remove(symbol:from:)``
- ``Tradier.CodableService/deleteWatchlist(id:)``

### Profiles & Balances

- ``Tradier.CodableService/userProfile()``
- ``Tradier.CodableService/accountProfile(for:)``
- ``Tradier.CodableService/accountBalances(for:)``

### Positions & Activity

- ``Tradier.CodableService/accountPositions(for:)``
- ``Tradier.CodableService/accountHistory(for:start:end:type:)``
- ``Tradier.CodableService/accountGainLoss(for:page:limit:sortBy:sort:start:end:symbol:)``

### Orders

- ``Tradier.CodableService/placeOrder(accountId:symbol:side:quantity:type:duration:price:)``
