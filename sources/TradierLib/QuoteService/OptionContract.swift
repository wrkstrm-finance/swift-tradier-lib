import Foundation

extension Tradier {
  /// Generates an OCC OSI–style option contract symbol.
  ///
  /// The symbol is composed of the option root, expiration date formatted as
  /// `yyMMdd`, a single character denoting the option kind, and the strike
  /// price expressed in thousandths of a dollar padded to eight digits.
  /// See the Options Clearing Corporation's OSI specification for details.
  ///
  /// Example:
  /// ```swift
  /// let calendar = Calendar(identifier: .gregorian)
  /// let expiration = calendar.date(from: DateComponents(year: 2022, month: 6, day: 24))!
  /// Tradier.optionContract(root: "NKE", expiration: expiration, kind: .call, strike: 99)
  /// // "NKE220624C00099000"
  /// ```
  public static func optionContract(
    root: String,
    expiration: Date,
    kind: Option.Kind,
    strike: Decimal,
    calendar: Calendar = .current,
  ) -> String {
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.dateFormat = "yyMMdd"
    let dateString = formatter.string(from: expiration)

    // Convert dollars to thousandths of a dollar as required by the OCC OSI specification.
    let scaled = strike * 1000
    let rounded = (scaled as NSDecimalNumber).rounding(
      accordingToBehavior: Self.optionContractRoundingHandler)
    let strikeInt = rounded.intValue
    let strikeString = String(format: "%08d", strikeInt)

    return root + dateString + kind.rawValue + strikeString
  }

  // Private static handler for option contract rounding
  private static let optionContractRoundingHandler = NSDecimalNumberHandler(
    roundingMode: .plain,
    scale: 0,
    raiseOnExactness: false,
    raiseOnOverflow: false,
    raiseOnUnderflow: false,
    raiseOnDivideByZero: false,
  )
}
