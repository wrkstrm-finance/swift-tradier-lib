// Overview: Options controlling event stream behavior (linebreak, validity, details).
// Used by TradierEventsClient.connect/update to shape payload.
import Foundation

/// Options that influence server-side formatting and filtering of events.

public struct TradierStreamOptions: Sendable {
  /// If true, server may split multi-events by linebreaks.
  public var linebreak: Bool
  /// If true, only valid events are returned.
  public var validOnly: Bool
  /// If true, includes additional details in event payloads.
  public var advancedDetails: Bool

  /// Creates a new options value.
  /// - Parameters:
  ///   - linebreak: Enable line breaks between events.
  ///   - validOnly: Filter to valid events only.
  ///   - advancedDetails: Request richer event payloads.
  public init(linebreak: Bool = true, validOnly: Bool = true, advancedDetails: Bool = false) {
    self.linebreak = linebreak
    self.validOnly = validOnly
    self.advancedDetails = advancedDetails
  }
}
