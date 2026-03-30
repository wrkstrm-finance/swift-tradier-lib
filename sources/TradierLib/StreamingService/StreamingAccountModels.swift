// Overview: Streaming account event model for fills and account updates.
// Used by TradierTradeStreamService to decode account events.
import Foundation

extension TradierTradeStreamService {
  /// Event emitted by the account streaming endpoint (e.g., fills).
  public struct TradierBrokerageAccountEventModel: Decodable {
    public let type: String
    public let transaction: Tradier.TradierBrokerageTransactionModel?
  }
}
