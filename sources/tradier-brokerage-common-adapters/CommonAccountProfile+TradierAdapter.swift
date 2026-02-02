import Foundation
import CommonBroker
import TradierLib

extension CommonAccountProfile {
  public init(_ tradierAccount: Tradier.AccountProfile) {
    let displayName: String?
    if let name = tradierAccount.name {
      let first = name.first ?? ""
      let last = name.last ?? ""
      let combined = [first, last].filter { !$0.isEmpty }.joined(separator: " ")
      displayName = combined.isEmpty ? nil : combined
    } else {
      displayName = nil
    }

    let address: CommonProfileAddress?
    if let a = tradierAccount.address {
      address = .init(
        address1: a.address1,
        address2: a.address2,
        city: a.city,
        state: a.state,
        postalCode: a.postalCode,
        country: a.country,
      )
    } else {
      address = nil
    }

    self.init(
      accountId: tradierAccount.accountNumber ?? "",
      status: tradierAccount.status,
      classification: tradierAccount.classification,
      displayName: displayName,
      accountType: tradierAccount.accountType,
      optionLevel: tradierAccount.optionLevel,
      dayTrader: tradierAccount.dayTrader,
      lastUpdated: tradierAccount.lastUpdated,
      email: tradierAccount.email,
      phone: tradierAccount.phone,
      address: address,
    )
  }
}
