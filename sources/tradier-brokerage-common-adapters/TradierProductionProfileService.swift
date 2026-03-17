import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain

public struct TradierProductionProfileService: CommonProfileService, Sendable {
  private let client: any TradierProfileClient
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType = .production

  public init(environment: Tradier.HTTPSProdEnvironment = .init()) {
    client = Tradier.CodableService(environment: environment)
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(
    environment: Tradier.HTTPSProdEnvironment = .init(),
    parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable
  ) {
    client = Tradier.CodableService(environment: environment, json: parser)
  }

  #if DEBUG
  public init(client: any TradierProfileClient) { self.client = client }
  #endif

  public func userProfile() async throws -> CommonUserProfile {
    let response: Tradier.UserProfile = try await client.userProfile()
    return CommonUserProfile(response)
  }

  public func accountProfile(for accountId: String) async throws -> CommonAccountProfile {
    let response: Tradier.AccountProfile = try await client.accountProfile(for: accountId)
    return CommonAccountProfile(response)
  }

  public func accountBalances(for accountId: String) async throws -> CommonAccountBalance {
    let response: Tradier.Balance = try await client.accountBalances(for: accountId)
    return CommonAccountBalance(response)
  }
}
