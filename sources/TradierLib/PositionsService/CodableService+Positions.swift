// Overview: Positions retrieval for Tradier.CodableService.
// Provides live account positions and convenience import wrapper.
// Related: Positions+Codable.swift, CodableURLRequest+Positions.swift
import Foundation

extension Tradier.CodableService {
  /// Returns current open positions for the specified account.
  public func accountPositions(for accountId: String) async throws -> [Tradier.Position] {
    let request = Tradier.AccountPositionsRequest(accountId: accountId)
    let response = try await client.send(request)
    return response.positions?.position ?? []
  }

  /// Convenience wrapper for `accountPositions(for:)`.
  public func importLivePositions(for accountId: String) async throws -> [Tradier.Position] {
    try await accountPositions(for: accountId)
  }
}
