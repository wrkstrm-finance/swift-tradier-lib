import Foundation
import SwiftUniversalMain

extension Tradier {
  public struct GainLossRoot: Decodable, Sendable {
    public var gainloss: GainLoss?

    private enum CodingKeys: String, CodingKey { case gainloss }
  }

  public struct GainLoss: Decodable, Sendable {
    public var closedPosition: [ClosedPosition]?

    private enum CodingKeys: String, CodingKey { case closedPosition }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      closedPosition = try container.decodeArrayAllowingNullOrSingle(
        ClosedPosition.self,
        forKey: .closedPosition,
      )
    }
  }

  /// Represents a closed position in a financial account, including details about the trade and its outcome.
  public struct ClosedPosition: Decodable, Hashable, Sendable {
    /// The date when the position was closed (sold or otherwise exited).
    public var closeDate: Date?
    /// The total cost basis for the position, i.e., the amount originally paid to acquire the position.
    public var cost: Double?
    /// The net gain or loss realized from closing the position (proceeds minus cost).
    public var gainLoss: Double?
    /// The percentage gain or loss realized from closing the position, relative to the cost.
    public var gainLossPercent: Double?
    /// The date when the position was opened (acquired).
    public var openDate: Date?
    /// The total proceeds received from closing the position (e.g., sale amount before subtracting cost).
    public var proceeds: Double?
    /// The quantity of shares or units involved in the position.
    public var quantity: Double?
    /// The symbol (ticker) of the security for the position.
    public var symbol: String?
    /// The holding period of the position in days (the term between open and close dates).
    public var term: Int?

    private enum CodingKeys: String, CodingKey {
      case closeDate
      case cost
      case gainLoss
      case gainLossPercent
      case openDate
      case proceeds
      case quantity
      case symbol
      case term
    }
  }
}
