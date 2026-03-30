import Foundation
import CommonBroker
import TradierLib
import SwiftUniversalFoundation
import SwiftUniversalFoundation
import SwiftUniversalMain
import WrkstrmNetworking

extension CommonBrokerageSymbolModel {
  init(_ s: Tradier.TradierBrokerageSecurityModel) {
    self.init(
      symbol: s.symbol,
      name: s.description,
      exchange: s.exchange,
      type: s.type,
    )
  }
}

public struct TradierReferenceService: CommonReferenceService, Sendable {
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
      fatalError("Incompatible environment for TradierReferenceService.")
    }
  }

  /// Instrumented initializer allowing a custom response decoder.
  public init(
    environment: HTTP.Environment,
    parser: any SwiftUniversalFoundation.JSONDataDecoding & Sendable
  ) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierReferenceService.")
    }
  }

  public func searchSymbols(_ query: String) async throws -> [CommonBrokerageSymbolModel] {
    let results: [Tradier.TradierBrokerageSecurityModel] = try await client.symbolLookup(query: query)
    return results.map(CommonBrokerageSymbolModel.init)
  }
}
