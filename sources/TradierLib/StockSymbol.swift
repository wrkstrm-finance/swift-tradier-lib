public struct StockSymbol: Codable, Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool { lhs.symbol < rhs.symbol }

  public var symbol: String

  public var name: String

  public var sector: String

  public init(symbol: String, name: String, sector: String) {
    self.symbol = symbol
    self.name = name
    self.sector = sector
  }
}

public enum Sector: String {
  case materials = "Materials"

  case financials = "Financials"

  case healthCare = "Health Care"

  case utilities = "Utilities"

  case telecommunication = "Telecommunication Services"

  case staples = "Consumer Staples"

  case energy = "Energy"

  case industrials = "Industrials"

  case technology = "Information Technology"

  case realEstate = "Real Estate"

  case discretionary = "Consumer Discretionary"
}
