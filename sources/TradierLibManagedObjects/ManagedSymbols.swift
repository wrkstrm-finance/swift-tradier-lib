#if canImport(CoreData)
import CoreData
import Foundation
import TradierLib

extension StockSymbol {
  @MainActor
  public static func symbols(with context: NSManagedObjectContext) -> [Self] {
    Bundle.main.decode(
      [StockSymbol].self,
      from: "sp500-2017",
      decoder: Managed.decoder(with: context),
    )
  }
}
#endif
