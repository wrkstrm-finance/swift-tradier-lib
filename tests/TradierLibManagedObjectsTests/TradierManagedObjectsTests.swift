#if canImport(CoreData)
import CoreData
import Testing

@testable import TradierLibManagedObjects

@Suite("TradierManagedObjects")
struct TradierManagedObjectsTests {
  @Test
  func codingUserInfoKeyExists() {
    #expect(CodingUserInfoKey.managedObjectContext.rawValue == "managedObjectContext")
  }
}
#endif
