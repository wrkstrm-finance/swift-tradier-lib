#if canImport(CoreData)
import CoreData
import Foundation
import TradierLib

extension Managed {
  /*
    This function should be called on the main actor.
    Pass in the managed object context explicitly.
   */
  @MainActor
  public static func decoder(with context: NSManagedObjectContext) -> JSONDecoder {
    let decoder: JSONDecoder = .init()
    decoder.dateDecodingStrategy = .custom(Tradier.customDateDecoder)
    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
    return decoder
  }
}
#endif
