import Foundation
import WrkstrmNetworking

extension Tradier {
  public struct SymbolLookupRequest: HTTP.CodableURLRequest {
    public typealias ResponseType = Tradier.LookupRoot
    public var method: HTTP.Method { .get }
    public var path: String { "markets/lookup" }
    public var options: HTTP.Request.Options

    public init(query: String) {
      options = .make { q in
        q.add("q", value: query)
      }
    }
  }
}
