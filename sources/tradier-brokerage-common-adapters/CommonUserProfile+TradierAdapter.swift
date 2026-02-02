import Foundation
import CommonBroker
import TradierLib

extension CommonUserProfile {
  public init(_ tradierUser: Tradier.UserProfile) {
    self.init(
      id: tradierUser.id,
      name: tradierUser.name,
      email: "N/A",
    )
  }
}
