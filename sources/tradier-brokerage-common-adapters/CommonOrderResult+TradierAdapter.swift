import Foundation
import CommonBroker
import TradierLib

extension CommonOrderResult {
  public init(_ result: Tradier.OrderResult) {
    self.init(
      id: result.id,
      status: result.status,
      partnerId: result.partnerId,
    )
  }
}
