import Foundation
import WrkstrmFoundation
import WrkstrmNetworking

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct TradierClient: Sendable {
  private let http: HTTP.JSONClient

  public init(
    environment: any HTTP.Environment = Tradier.HTTPSSandboxEnvironment(),
    configuration: URLSessionConfiguration = .default,
  ) {
    http = HTTP.JSONClient(
      environment: environment,
      json: (.commonDateFormatting, .commonDateParsing),
      configuration: configuration,
    )
  }

  public func fetchAccounts() async throws -> [String] {
    let json: [String: Any] = try await http.send(Tradier.UserProfileRequest())
    let data: Data = try JSONSerialization.data(withJSONObject: json)
    let profile: Tradier.UserProfile = try JSONDecoder.commonDateParsing.decode(
      Tradier.UserProfileRoot.self,
      from: data,
    ).profile
    return profile.accounts.map(\.accountNumber)
  }
}
