import Foundation

extension Tradier.CodableService {
  /// Performs a symbol lookup against Tradier's reference endpoint.
  /// - Parameter query: A partial symbol or company name.
  /// - Returns: A list of matching securities with symbol, description, and optional exchange/type.
  public func symbolLookup(query: String) async throws -> [Tradier.TradierBrokerageSecurityModel] {
    let request: Tradier.SymbolLookupRequest = .init(query: query)
    let resp: Tradier.TradierBrokerageLookupRootModel = try await client.send(request)
    return resp.securities?.security ?? []
  }
}
