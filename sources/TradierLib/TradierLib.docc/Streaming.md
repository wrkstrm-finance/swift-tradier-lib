# Streaming

Use `TradierEventsClient` to subscribe to market events over WebSockets.
Provide a session id, a list of symbols, and optional `TradierStreamOptions`.

The client exposes an `AsyncStream` of `TradierEvent` values.

## Topics

### Client & Options

- ``TradierEventsClient``
- ``TradierEventsClient/Config``
- ``TradierStreamOptions``

### Event Types

- ``TradierEvent``
- ``Quote``
- ``Trade``
- ``Summary``
- ``TimeSale``
- ``TradeX``
