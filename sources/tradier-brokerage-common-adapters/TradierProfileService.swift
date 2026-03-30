import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

public protocol TradierProfileClient: Sendable {
  func userProfile() async throws -> Tradier.TradierBrokerageUserProfileModel
  func accountProfile(for accountId: String) async throws -> Tradier.TradierBrokerageAccountProfileModel
  func accountBalances(for accountId: String) async throws -> Tradier.TradierBrokerageBalanceModel
}

extension Tradier.CodableService: TradierProfileClient {}

public struct TradierProfileService: CommonProfileService, Sendable {
  private let client: any TradierProfileClient
  public nonisolated let serviceName: String = "Tradier"
  public nonisolated let serviceType: ServiceType

  public init(environment: HTTP.Environment) {
    client = Tradier.CodableService(environment: environment)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierPositionsService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(environment: HTTP.Environment, parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierPositionsService.")
    }
  }

  #if DEBUG
  // Test-only initializer for injecting a mock client
  public init(client: any TradierProfileClient) {
    self.client = client
    serviceType = .sandbox
  }
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
