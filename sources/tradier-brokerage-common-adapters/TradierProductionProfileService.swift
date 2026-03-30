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

  public func userProfile() async throws -> CommonBrokerageUserProfileModel {
    let response: Tradier.TradierBrokerageUserProfileModel = try await client.userProfile()
    return CommonBrokerageUserProfileModel(response)
  }

  public func accountProfile(for accountId: String) async throws -> CommonBrokerageAccountProfileModel {
    let response: Tradier.TradierBrokerageAccountProfileModel = try await client.accountProfile(for: accountId)
    return CommonBrokerageAccountProfileModel(response)
  }

  public func accountBalances(for accountId: String) async throws -> CommonBrokerageAccountBalanceModel {
    let response: Tradier.TradierBrokerageBalanceModel = try await client.accountBalances(for: accountId)
    return CommonBrokerageAccountBalanceModel(response)
  }
}
