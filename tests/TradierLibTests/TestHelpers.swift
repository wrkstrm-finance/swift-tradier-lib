import Foundation

extension Bundle {
  func json(named name: String) throws -> Data {
    guard let url: URL = url(forResource: name, withExtension: "json") else {
      throw URLError(.fileDoesNotExist)
    }
    return try Data(contentsOf: url)
  }
}
