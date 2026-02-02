import Foundation
import CommonLog
import WrkstrmNetworking

public enum Tradier {
  public struct HTTPSProdEnvironment: HTTP.Environment {
    public var apiKey: String? = ""
    public var scheme: HTTP.Scheme = .https
    public var host: String
    public var apiVersion: String?
    public var clientVersion: String?

    public var headers: [String: String] {
      [
        "Accept": "application/json",
        "Authorization": "Bearer \(apiKey ?? "")",
      ]
    }

    public init(
      apiKey: String? = nil,
      scheme: HTTP.Scheme = .https,
      host: String = "api.tradier.com",
      apiVersion: String? = "v1",
      clientVersion: String? = nil,
    ) {
      let resolvedKey =
        apiKey ?? ProcessInfo.processInfo.environment["TRADIER_API_KEY"] ?? ""
      if resolvedKey.isEmpty {
        Log.error("TRADIER_API_KEY environment variable must be set")
      }
      self.apiKey = resolvedKey
      self.scheme = scheme
      self.host = host
      self.apiVersion = apiVersion
      self.clientVersion = clientVersion
    }
  }

  public struct HTTPSSandboxEnvironment: HTTP.Environment {
    public var apiKey: String?
    public var scheme: HTTP.Scheme = .https
    public var host: String
    public var apiVersion: String?
    public var clientVersion: String?

    public var headers: [String: String] {
      [
        "Accept": "application/json",
        "Authorization": "Bearer \(apiKey ?? "")",
      ]
    }

    public init(
      apiKey: String? = nil,
      scheme: HTTP.Scheme = .https,
      host: String = "sandbox.tradier.com",
      apiVersion: String? = "v1",
      clientVersion: String? = nil,
    ) {
      let resolvedKey =
        apiKey ?? ProcessInfo.processInfo.environment["TRADIER_SANDBOX_API_KEY"]
        ?? ""
      if resolvedKey.isEmpty {
        Log.error(
          "API key must be provided either via the apiKey parameter or the TRADIER_SANDBOX_API_KEY environment variable",
        )
      }
      self.apiKey = resolvedKey
      self.scheme = scheme
      self.host = host
      self.apiVersion = apiVersion
      self.clientVersion = clientVersion
    }
  }
}
