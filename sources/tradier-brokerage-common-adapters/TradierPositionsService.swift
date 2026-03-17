import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

public struct TradierPositionsService: CommonPositionsService, Sendable {
  private let client: Tradier.CodableService
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

  public func positions(for accountId: String) async throws -> [CommonPosition] {
    let positions: [Tradier.Position] = try await client.accountPositions(for: accountId)
    return positions.map(CommonPosition.init)
  }

  public func livePositions(for accountId: String) async throws -> [CommonPosition] {
    try await positions(for: accountId)
  }
}
