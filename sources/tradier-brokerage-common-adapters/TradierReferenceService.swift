import Foundation
import CommonBroker
import TradierLib
import WrkstrmFoundation
import WrkstrmMain
import WrkstrmNetworking

extension CommonSymbol {
  init(_ s: Tradier.Security) {
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

  /// Instrumented initializer allowing a custom JSON parser.
  public init(environment: HTTP.Environment, parser: JSON.Parser) {
    client = Tradier.CodableService(environment: environment, json: parser)
    if environment is Tradier.HTTPSSandboxEnvironment {
      serviceType = .sandbox
    } else if environment is Tradier.HTTPSProdEnvironment {
      serviceType = .production
    } else {
      fatalError("Incompatible environment for TradierReferenceService.")
    }
  }

  public func searchSymbols(_ query: String) async throws -> [CommonSymbol] {
    let results: [Tradier.Security] = try await client.symbolLookup(query: query)
    return results.map(CommonSymbol.init)
  }
}
