// Overview: Profile and balances methods for Tradier.CodableService.
// Fetches user profile, account profile, and balances.
// Related: Profile+Codable.swift, Balances+Codable.swift, CodableURLRequest+Profile.swift
import Foundation

extension Tradier.CodableService {
  /// Returns balances for the specified account id.
  public func accountBalances(for accountId: String) async throws -> Tradier.TradierBrokerageBalanceModel {
    let request: Tradier.AccountBalancesRequest = .init(accountId: accountId)
    let response: Tradier.TradierBrokerageBalancesRootModel = try await client.send(request)
    return response.balances
  }

  /// Returns profile details for the specified account id.
  public func accountProfile(for accountId: String) async throws -> Tradier.TradierBrokerageAccountProfileModel {
    let request: Tradier.AccountProfileRequest = .init(accountId: accountId)
    let response: Tradier.TradierBrokerageProfileRootModel = try await client.send(request)
    return response.profile
  }

  /// Returns the authenticated user’s profile.
  public func userProfile() async throws -> Tradier.TradierBrokerageUserProfileModel {
    let request: Tradier.UserProfileRequest = .init()
    let response: Tradier.TradierBrokerageUserProfileRootModel = try await client.send(request)
    return response.profile
  }
}
