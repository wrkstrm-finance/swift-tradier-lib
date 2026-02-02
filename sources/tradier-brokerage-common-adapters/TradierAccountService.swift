import TradierLib
import CommonBroker

public struct TradierAccountService: AccountService {
  private let client: TradierClient

  public init(client: TradierClient = .init()) {
    self.client = client
  }

  public func accountNumbers() async throws -> [String] {
    try await client.fetchAccounts()
  }
}
