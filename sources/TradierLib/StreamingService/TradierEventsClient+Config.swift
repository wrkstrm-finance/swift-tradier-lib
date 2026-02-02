// Overview: Configuration for TradierEventsClient (endpoint URL + auth header).
// Defaults to markets events WebSocket endpoint.
import Foundation

extension TradierEventsClient {
  /// Configuration for `TradierEventsClient` endpoints and auth.
  public struct Config: Sendable {
    /// WebSocket endpoint URL (markets events by default).
    public var url: URL
    /// Optional auth header pair to include in the upgrade request.
    public var authHeader: (name: String, value: String)?

    /// Creates a new configuration.
    /// - Parameters:
    ///   - url: Events endpoint URL.
    ///   - authHeader: Optional header tuple (e.g. ("Authorization", "Bearer ...")).
    public init(
      url: URL = URL(string: "wss://ws.tradier.com/v1/markets/events")!,
      authHeader: (String, String)? = nil,
    ) {
      self.url = url
      self.authHeader = authHeader
    }
  }
}
