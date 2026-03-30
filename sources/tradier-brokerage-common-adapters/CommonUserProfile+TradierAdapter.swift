import Foundation
import CommonBroker
import TradierLib

extension CommonBrokerageUserProfileModel {
  public init(_ tradierUser: Tradier.TradierBrokerageUserProfileModel) {
    self.init(
      id: tradierUser.id,
      name: tradierUser.name,
      email: "N/A",
    )
  }
}
