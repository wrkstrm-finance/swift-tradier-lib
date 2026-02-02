// Overview: Builds subscribe/update payloads for Tradier streaming API.
// Consumed by TradierEventsClient.sendPayload(...).
import Foundation

enum StreamingPayloadBuilder {
  static func build(
    sessionId: String,
    symbols: [String],
    filters: [String]?,
    options: TradierStreamOptions,
  ) -> [String: Any] {
    var p: [String: Any] = [
      "symbols": symbols,
      "sessionid": sessionId,
      "linebreak": options.linebreak,
      "validOnly": options.validOnly,
      "advancedDetails": options.advancedDetails,
    ]
    if let filters, !filters.isEmpty { p["filter"] = filters }
    return p
  }
}
