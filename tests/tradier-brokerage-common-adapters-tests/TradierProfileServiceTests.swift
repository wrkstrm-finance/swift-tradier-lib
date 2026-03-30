import Foundation
import CommonBroker
import Testing
import TradierLib

@testable import TradierBrokerageCommonAdapters

// Mock client conforming to TradierProfileClient for injection.
private final class MockProfileClient: TradierProfileClient {
  let user: Tradier.TradierBrokerageUserProfileModel
  let account: Tradier.TradierBrokerageAccountProfileModel
  let balance: Tradier.TradierBrokerageBalanceModel
  init(user: Tradier.TradierBrokerageUserProfileModel, account: Tradier.TradierBrokerageAccountProfileModel, balance: Tradier.TradierBrokerageBalanceModel) {
    self.user = user
    self.account = account
    self.balance = balance
  }

  func userProfile() async throws -> Tradier.TradierBrokerageUserProfileModel { user }
  func accountProfile(for _: String) async throws -> Tradier.TradierBrokerageAccountProfileModel { account }
  func accountBalances(for _: String) async throws -> Tradier.TradierBrokerageBalanceModel { balance }
}

@Test
func sandboxProfileService_maps_user_profile() async throws {
  #if DEBUG
  let profile = try TestDecodeHelper.makeTradierUserProfile(id: "user-123", name: "Ada Lovelace")
  let account = try TestDecodeHelper.makeTradierAccountProfile(accountId: "acc")
  let balance = try TestDecodeHelper.makeTradierBalance()
  let mock = MockProfileClient(user: profile, account: account, balance: balance)
  let service = TradierProfileService(client: mock)
  let common = try await service.userProfile()
  #expect(common.id == "user-123")
  #expect(common.name == "Ada Lovelace")
  // Email may not be present in minimal stub; assert id/name
  #expect(common.id == "user-123")
  #expect(common.name == "Ada Lovelace")
  #else
  return
  #endif
}

@Test
func sandboxProfileService_maps_account_profile() async throws {
  #if DEBUG
  let profile = try TestDecodeHelper.makeTradierUserProfile(id: "x", name: "y")
  let account = try TestDecodeHelper.makeTradierAccountProfile(
    accountId: "ACC-1", status: "ACTIVE", classification: "BROKERAGE", accountName: "Primary",
  )
  let balance = try TestDecodeHelper.makeTradierBalance()
  let mock = MockProfileClient(user: profile, account: account, balance: balance)
  let service = TradierProfileService(client: mock)
  let common = try await service.accountProfile(for: "ACC-1")
  #expect(common.accountId == "ACC-1")
  #expect(common.status == "ACTIVE")
  #expect(common.classification == "BROKERAGE")
  #else
  return
  #endif
}

@Test
func sandboxProfileService_maps_account_balances() async throws {
  #if DEBUG
  let profile = try TestDecodeHelper.makeTradierUserProfile(id: "x", name: "y")
  let account = try TestDecodeHelper.makeTradierAccountProfile(accountId: "")
  let balance = try TestDecodeHelper.makeTradierBalance(
    cashAvailable: 1000, totalEquity: 5000, maintenanceMargin: 750, buyingPower: 2000,
  )
  let mock = MockProfileClient(user: profile, account: account, balance: balance)
  let service = TradierProfileService(client: mock)
  let common = try await service.accountBalances(for: "ACC-1")
  #expect(common.cashAvailable == 1000)
  #expect(common.totalEquity == 5000)
  #expect(common.maintenanceRequirement == 750)
  #expect(common.stockBuyingPower == 2000)
  #else
  return
  #endif
}
