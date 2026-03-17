#if canImport(CoreData)
import CoreData
import Foundation
import SwiftUniversalFoundation

extension Managed.QuotesRoot {
  @MainActor
  public static func aaplQuote(with context: NSManagedObjectContext) -> Self {
    Bundle.main.decode(
      Self.self,
      from: "aapl_quote",
      decoder: Managed.decoder(with: context),
    )
  }
}
#endif
