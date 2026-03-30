import Foundation

extension Tradier {
  /// Known error codes returned by Tradier API.
  ///
  /// Each case maps a response code to a human-readable message.
  public enum ResponseError: String, Error, Decodable, Sendable {
    /// Account is disabled for trading. Please contact 980-272-3880 for questions or concerns.
    case accountDisabled = "AccountDisabled"
    /// Account is not approved for trading. Please contact 980-272-3880 for questions or
    /// concerns
    case accountIsNotApproved = "AccountIsNotApproved"
    /// Margin rules prohibit this transaction. Please contact 980-272-3880 for questions or
    /// concerns
    case accountMarginRuleViolation = "AccountMarginRuleViolation"
    /// The order requested is not available for your account. Please contact 980-272-3880 for
    /// questions or concerns
    case assetTradingNotConfiguredForAccount = "AssetTradingNotConfiguredForAccount"
    /// Buy Stop order must have a Stop price greater than the current Ask price
    case buyStopOrderStopPriceLessAsk = "BuyStopOrderStopPriceLessAsk"
    /// Placement Condition: when {0} {1} is {2} than {3}
    case contingentOrderExecution = "ContingentOrderExecution"
    /// Your day trade limit exceeded. Please contact 980-272-3880 for questions or concerns
    case dayTraderPatternRestriction = "DayTraderPatternRestriction"
    /// There is not enough day trading buying power for the requested order
    case dayTradingBuyingPowerExceeded = "DayTradingBuyingPowerExceeded"
    /// Expiration date for option is not defined
    case expirationDateUndefined = "ExpirationDateUndefined"
    /// Quantity should be between 1 and 10,000,000
    case incorrectOrderQuantity = "IncorrectOrderQuantity"
    /// Time In Force (Day or GTC) is not defined
    case incorrectTimeInForce = "IncorrectTimeInForce"
    /// Multi TradierBrokerageQuoteLegModel Orders with Index options must have all legs within 1 expiration date. Time
    /// spreads are not allowed on Index Options
    case indexOptionsOneExparyDate = "IndexOptionsOneExparyDate"
    /// You do not have enough buying power for this trade
    case initialMargin = "InitialMargin"
    /// Expiration date must be greater than the current date
    case invalidOrderExpiration = "InvalidOrderExpiration"
    /// Limit price is not valid. Please check the price entered
    case limitPriceUndefined = "LimitPriceUndefined"
    /// Account is restricted for option trading. Please contact 980-272-3880 for questions or
    /// concerns
    case longOptionTradingDeniedForAccount = "LongOptionTradingDeniedForAccount"
    /// Sell order is for more shares than your current long position, please review current
    /// position quantity along with open orders for security.
    case longPositionCrossZero = "LongPositionCrossZero"
    /// You do not have enough buying power for this trade
    case maintenanceMargin = "MaintenanceMargin"
    /// You cannot place market orders with GTC, only day orders are allowed
    case marketOrderIsGtc = "MarketOrderIsGtc"
    /// Expiration type of OCO orders must be the same
    case ocoExpirationTypeNotTheSame = "OcoExpirationTypeNotTheSame"
    /// You cannot place OCO order with orders for the same security and with opposite trade
    /// direction
    case ocoOrderWithOppositeLegs = "OcoOrderWithOppositeLegs"
    /// OCO price difference should be at least {0}$
    case ocoPriceDifferenceIsLessThanDelta = "OcoPriceDifferenceIsLessThanDelta"
    /// Your order could not be processed. Please contact 980-272-3880 for questions or concerns
    case omsInternalError = "OmsInternalError"
    /// Trading services are not available online currently, please contact 980-272-3880 for
    /// order requests
    case omsUnavailable = "OmsUnavailable"
    /// Your account does not have the option level permission for this trade. Please contact
    /// 980-272-3880 for questions or concerns
    case optionLevelRestriction = "OptionLevelRestriction"
    /// Type of option (call or put) is not defined
    case optionTypeUndefined = "OptionTypeUndefined"
    /// Change of order's contingent is not allowed
    case orderContingentChangeNotAllowed = "OrderContingentChangeNotAllowed"
    /// TradierBrokerageOrderModel is not allowed. Account trading restriction: closing orders only
    case orderIsNotAllowedForAccount = "OrderIsNotAllowedForAccount"
    /// Price of {0} {1} order is {2} than market price
    case orderPriceIsInvalid = "OrderPriceIsInvalid"
    /// You cannot place orders with quantity less than 1
    case orderQuantity = "OrderQuantity"
    /// You cannot have pending orders with different sides for selected symbol where one is a
    // MARK: T order. You must close another pending order in order to place a SHORT order, or
    /// try a limit order instead
    case orderWithDifferentSide = "OrderWithDifferentSide"
    /// First market order in OTO is not allowed
    case otoFirstLesIsMarketNotAllowed = "OtoFirstLesIsMarketNotAllowed"
    /// OCO market orders are not allowed
    case otoOcoMarketNotAllowed = "OtoOcoMarketNotAllowed"
    /// OTO/OCO trailing orders are not allowed
    case otoOcoTrailingNotAllowed = "OtoOcoTrailingNotAllowed"
    /// There is no quote for the symbol requested, please contact 980-272-3880 to place the
    /// order.
    case quotePriceIsInvalid = "QuotePriceIsInvalid"
    /// Symbol does not exist. Please contact 980-272-3880 for questions or concerns
    case securityUndefined = "SecurityUndefined"
    /// Sell Short order cannot be placed for stock priced below $5
    case sellShortOrderLastPriceBelow5 = "SellShortOrderLastPriceBelow5"
    /// Sell Stop order must have a Stop price less than the Bid price
    case sellStopOrderStopPriceGreaterBid = "SellStopOrderStopPriceGreaterBid"
    /// Account is restricted for option trading. Please contact 980-272-3880 for questions or
    /// concerns
    case shortOptionTradingDeniedForAccount = "ShortOptionTradingDeniedForAccount"
    /// You cannot place short stock orders with GTC, only day orders are allowed
    case shortOrderIsGtc = "ShortOrderIsGtc"
    /// Buy order is for more shares than your current short position, please review current
    /// position quantity along with open orders for security.
    case shortPositionCrossZero = "ShortPositionCrossZero"
    /// Account is restricted from short sales. Please contact 980-272-3880 for questions or
    /// concerns
    case shortStockTradingDeniedForAccount = "ShortStockTradingDeniedForAccount"
    /// This symbol is not available for short sales. Please contact 980-272-3880 for questions
    /// or concerns
    case shortTradingDeniedForSecurity = "ShortTradingDeniedForSecurity"
    /// Account is restricted for spread trading. Please contact 980-272-3880 for questions or
    /// concerns
    case spreadTradingDeniedForAccount = "SpreadTradingDeniedForAccount"
    /// Stop price is not defined
    case stopPriceUndefined = "StopPriceUndefined"
    /// Strike price for option leg is not defined
    case strikePriceUndefined = "StrikePriceUndefined"
    /// Pattern Day Trader Rule violation: Equity balance fell below $25,000
    case tooSmallEquityForDayTrading = "TooSmallEquityForDayTrading"
    /// You do not have enough buying power for this trade
    case totalInitialMargin = "TotalInitialMargin"
    /// You cannot place an order with non standard options
    case tradeNonStandartOptions = "TradeNonStandartOptions"
    /// Account is restricted for trading. Please contact 980-272-3880 for questions or concerns
    case tradingDeniedForAccount = "TradingDeniedForAccount"
    /// This asset class is restricted for trading
    case tradingDeniedForSecurity = "TradingDeniedForSecurity"
    /// Buy order cannot be placed to cover short position, order must be placed as a Buy to
    /// Cover
    case unexpectedBuyOrder = "UnexpectedBuyOrder"
    /// Buy To Open order cannot be placed to close a short option position, order must be
    /// placed as a Buy to Close
    case unexpectedBuyOrderOption = "UnexpectedBuyOrderOption"
    /// Buy To Cover order cannot be placed unless closing a short position, please check open
    /// orders.
    case unexpectedBuyToCoverOrder = "UnexpectedBuyToCoverOrder"
    /// Buy To Close order cannot be placed unless closing a short option position, please check
    /// open orders.
    case unexpectedBuyToCoverOrderOption = "UnexpectedBuyToCoverOrderOption"
    /// Sell order cannot be placed unless you are closing a long position, please check open
    /// orders.
    case unexpectedSellOrder = "UnexpectedSellOrder"
    /// Sell to Close order cannot be placed unless you are closing a long option position,
    /// please check open orders.
    case unexpectedSellOrderOption = "UnexpectedSellOrderOption"
    /// Sell short order cannot be placed while you have a current long position, please check
    /// open orders.
    case unexpectedSellShortOrder = "UnexpectedSellShortOrder"
    /// Sell to Open order cannot be placed while you have a current long option position,
    /// please check open orders.
    case unexpectedSellShortOrderOption = "UnexpectedSellShortOrderOption"
    /// Account is disabled for trading. Please contact 980-272-3880 for questions or concerns
    case userDisabled = "UserDisabled"
    /// You are unable to place orders on the same security and same price in different
    /// direction
    case washTradeAttempt = "WashTradeAttempt"
    /// Pre-market trading is currently unavailable.
    case preMarketTradingUnavailable = "PreMarketTradingUnavailable"
    /// Tradier Brokerage does not accept opening orders for OTC-BB and Pink Sheet securities,
    /// please contact us at (980)-272-3880 if you have any questions.
    case openingOrdersForOTCBBNotAccepted = "OpeningOrdersForOTCBBNotAccepted"
    /// Due to price volatility a limit order must be placed.
    case limitOrderRequiredDueToPriceVolatility = "LimitOrderRequiredDueToPriceVolatility"
    /// Outside of market hours this order is required to be placed at a limit price.
    case limitOrderRequiredOutsideMarketHours = "LimitOrderRequiredOutsideMarketHours"
    /// TradierBrokerageOrderModel failed PriceRange - AGGRESSIVE: OrderPrice {1} RefPrice {2} Limit {3} aggressive
    case orderFailedPriceRangeAggressive = "OrderFailedPriceRangeAggressive"

    /// Human-readable description of the error code.
    public var message: String {
      switch self {
      case .accountDisabled:
        NSLocalizedString(
          "Account is disabled for trading. Please contact 980-272-3880 for "
            + "questions or concerns.",
          comment: """
              Tradier API error code 'AccountDisabled'. Trader sees this when the brokerage returns
              this code. Account is disabled for trading. Please contact 980-272-3880 for \
            questions or
              concerns. Translators: retain phone numbers like 980-272-3880 and keep trading \
            acronyms
              (GTC, OCO) unchanged.
            """,
        )

      case .accountIsNotApproved:
        NSLocalizedString(
          "Account is not approved for trading. Please contact 980-272-3880 for"
            + "questions or concerns",
          comment: """
              Tradier API error code 'AccountIsNotApproved'. Trader sees this when the brokerage
              returns this code. Account is not approved for trading. Please contact 980-272-3880 \
            for
              questions or concerns Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .accountMarginRuleViolation:
        NSLocalizedString(
          "Margin rules prohibit this transaction. Please contact 980-272-3880"
            + "for questions or concerns",
          comment: """
              Tradier API error code 'AccountMarginRuleViolation'. Trader sees this when the \
            brokerage
              returns this code. Margin rules prohibit this transaction. Please contact 980-272-3880
              for questions or concerns Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .assetTradingNotConfiguredForAccount:
        NSLocalizedString(
          "The order requested is not available for your account. Please contact"
            + "980-272-3880 for questions or concerns",
          comment: """
              Tradier API error code 'AssetTradingNotConfiguredForAccount'. Trader sees this when \
            the
              brokerage returns this code. The order requested is not available for your account.
              Please contact 980-272-3880 for questions or concerns Translators: retain phone \
            numbers
              like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .buyStopOrderStopPriceLessAsk:
        NSLocalizedString(
          "Buy Stop order must have a Stop price greater than the current Ask" + "price",
          comment: """
              Tradier API error code 'BuyStopOrderStopPriceLessAsk'. Trader sees this when the
              brokerage returns this code. Buy Stop order must have a Stop price greater than the
              current Ask price Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .contingentOrderExecution:
        NSLocalizedString(
          "Placement Condition: when {0} {1} is {2} than {3}",
          comment: """
              Tradier API error code 'ContingentOrderExecution'. Trader sees this when the brokerage
              returns this code. Placement Condition: when {0} {1} is {2} than {3 Translators: \
            retain
              phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .dayTraderPatternRestriction:
        NSLocalizedString(
          "Your day trade limit exceeded. Please contact 980-272-3880 for"
            + "questions or concerns",
          comment: """
              Tradier API error code 'DayTraderPatternRestriction'. Trader sees this when the
              brokerage returns this code. Your day trade limit exceeded. Please contact \
            980-272-3880
              for questions or concerns Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .dayTradingBuyingPowerExceeded:
        NSLocalizedString(
          "There is not enough day trading buying power for the requested order",
          comment: """
              Tradier API error code 'DayTradingBuyingPowerExceeded'. Trader sees this when the
              brokerage returns this code. There is not enough day trading buying power for the
              requested order Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .expirationDateUndefined:
        NSLocalizedString(
          "Expiration date for option is not defined",
          comment: """
              Tradier API error code 'ExpirationDateUndefined'. Trader sees this when the brokerage
              returns this code. Expiration date for option is not defined Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .incorrectOrderQuantity:
        NSLocalizedString(
          "Quantity should be between 1 and 10,000,000",
          comment: """
              Tradier API error code 'IncorrectOrderQuantity'. Trader sees this when the brokerage
              returns this code. Quantity should be between 1 and 10,000,000 Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .incorrectTimeInForce:
        NSLocalizedString(
          "Time In Force (Day or GTC) is not defined",
          comment: """
              Tradier API error code 'IncorrectTimeInForce'. Trader sees this when the brokerage
              returns this code. Time In Force (Day or GTC) is not defined Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .indexOptionsOneExparyDate:
        NSLocalizedString(
          "Multi TradierBrokerageQuoteLegModel Orders with Index options must have all legs within 1"
            + "expiration date. Time spreads are not allowed on Index Options",
          comment: """
              Tradier API error code 'IndexOptionsOneExparyDate'. Trader sees this when the \
            brokerage
              returns this code. Multi TradierBrokerageQuoteLegModel Orders with Index options must have all legs within 1
              expiration date. Time spreads are not allowed on Index Options Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .initialMargin:
        NSLocalizedString(
          "You do not have enough buying power for this trade",
          comment: """
              Tradier API error code 'InitialMargin'. Trader sees this when the brokerage returns \
            this
              code. You do not have enough buying power for this trade Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .invalidOrderExpiration:
        NSLocalizedString(
          "Expiration date must be greater than the current date",
          comment: """
              Tradier API error code 'InvalidOrderExpiration'. Trader sees this when the brokerage
              returns this code. Expiration date must be greater than the current date Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .limitPriceUndefined:
        NSLocalizedString(
          "Limit price is not valid. Please check the price entered",
          comment: """
              Tradier API error code 'LimitPriceUndefined'. Trader sees this when the brokerage
              returns this code. Limit price is not valid. Please check the price entered \
            Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .longOptionTradingDeniedForAccount:
        NSLocalizedString(
          "Account is restricted for option trading. Please contact 980-272-3880"
            + "for questions or concerns",
          comment: """
              Tradier API error code 'LongOptionTradingDeniedForAccount'. Trader sees this when the
              brokerage returns this code. Account is restricted for option trading. Please contact
              980-272-3880 for questions or concerns Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .longPositionCrossZero:
        NSLocalizedString(
          "Sell order is for more shares than your current long position, please"
            + "review current position quantity along with open orders for security.",
          comment: """
              Tradier API error code 'LongPositionCrossZero'. Trader sees this when the brokerage
              returns this code. Sell order is for more shares than your current long position, \
            please
              review current position quantity along with open orders for security. Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .maintenanceMargin:
        NSLocalizedString(
          "You do not have enough buying power for this trade",
          comment: """
              Tradier API error code 'MaintenanceMargin'. Trader sees this when the brokerage \
            returns
              this code. You do not have enough buying power for this trade Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .marketOrderIsGtc:
        NSLocalizedString(
          "You cannot place market orders with GTC, only day orders are allowed",
          comment: """
              Tradier API error code 'MarketOrderIsGtc'. Trader sees this when the brokerage returns
              this code. You cannot place market orders with GTC, only day orders are allowed
              Translators: retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, \
            OCO)
              unchanged.
            """,
        )

      case .ocoExpirationTypeNotTheSame:
        NSLocalizedString(
          "Expiration type of OCO orders must be the same",
          comment: """
              Tradier API error code 'OcoExpirationTypeNotTheSame'. Trader sees this when the
              brokerage returns this code. Expiration type of OCO orders must be the same \
            Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .ocoOrderWithOppositeLegs:
        NSLocalizedString(
          "You cannot place OCO order with orders for the same security and with"
            + "opposite trade direction",
          comment: """
              Tradier API error code 'OcoOrderWithOppositeLegs'. Trader sees this when the brokerage
              returns this code. You cannot place OCO order with orders for the same security and \
            with
              opposite trade direction Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .ocoPriceDifferenceIsLessThanDelta:
        NSLocalizedString(
          "OCO price difference should be at least {0}$",
          comment: """
              Tradier API error code 'OcoPriceDifferenceIsLessThanDelta'. Trader sees this when the
              brokerage returns this code. OCO price difference should be at least {0}$ Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .omsInternalError:
        NSLocalizedString(
          "Your order could not be processed. Please contact 980-272-3880 for"
            + "questions or concerns",
          comment: """
              Tradier API error code 'OmsInternalError'. Trader sees this when the brokerage returns
              this code. Your order could not be processed. Please contact 980-272-3880 for \
            questions
              or concerns Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .omsUnavailable:
        NSLocalizedString(
          "Trading services are not available online currently, please contact"
            + "980-272-3880 for order requests",
          comment: """
              Tradier API error code 'OmsUnavailable'. Trader sees this when the brokerage returns
              this code. Trading services are not available online currently, please contact
              980-272-3880 for order requests Translators: retain phone numbers like 980-272-3880 \
            and
              keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .optionLevelRestriction:
        NSLocalizedString(
          "Your account does not have the option level permission for this trade."
            + "Please contact 980-272-3880 for questions or concerns",
          comment: """
              Tradier API error code 'OptionLevelRestriction'. Trader sees this when the brokerage
              returns this code. Your account does not have the option level permission for this
              trade. Please contact 980-272-3880 for questions or concerns Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .optionTypeUndefined:
        NSLocalizedString(
          "Type of option (call or put) is not defined",
          comment: """
              Tradier API error code 'OptionTypeUndefined'. Trader sees this when the brokerage
              returns this code. Type of option (call or put) is not defined Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .orderContingentChangeNotAllowed:
        NSLocalizedString(
          "Change of order's contingent is not allowed",
          comment: """
              Tradier API error code 'OrderContingentChangeNotAllowed'. Trader sees this when the
              brokerage returns this code. Change of order's contingent is not allowed Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .orderIsNotAllowedForAccount:
        NSLocalizedString(
          "TradierBrokerageOrderModel is not allowed. Account trading restriction: closing orders only",
          comment: """
              Tradier API error code 'OrderIsNotAllowedForAccount'. Trader sees this when the
              brokerage returns this code. TradierBrokerageOrderModel is not allowed. Account trading restriction: \
            closing
              orders only Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .orderPriceIsInvalid:
        NSLocalizedString(
          "Price of {0} {1} order is {2} than market price",
          comment: """
              Tradier API error code 'OrderPriceIsInvalid'. Trader sees this when the brokerage
              returns this code. Price of {0} {1} order is {2} than market price Translators: retain
              phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .orderQuantity:
        NSLocalizedString(
          "You cannot place orders with quantity less than 1",
          comment: """
              Tradier API error code 'OrderQuantity'. Trader sees this when the brokerage returns \
            this
              code. You cannot place orders with quantity less than 1 Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .orderWithDifferentSide:
        NSLocalizedString(
          "You cannot have pending orders with different sides for selected"
            + "symbol where one is a MARKET order. You must close another pending"
            + "order in order to place a SHORT order, or try a limit order instead",
          comment: """
              Tradier API error code 'OrderWithDifferentSide'. Trader sees this when the brokerage
              returns this code. You cannot have pending orders with different sides for selected
              symbol where one is a MARKET order. You must close another pending order in order to
              place a SHORT order, or try a limit order instead Translators: retain phone numbers \
            like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .otoFirstLesIsMarketNotAllowed:
        NSLocalizedString(
          "First market order in OTO is not allowed",
          comment: """
              Tradier API error code 'OtoFirstLesIsMarketNotAllowed'. Trader sees this when the
              brokerage returns this code. First market order in OTO is not allowed Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .otoOcoMarketNotAllowed:
        NSLocalizedString(
          "OCO market orders are not allowed",
          comment: """
              Tradier API error code 'OtoOcoMarketNotAllowed'. Trader sees this when the brokerage
              returns this code. OCO market orders are not allowed Translators: retain phone numbers
              like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .otoOcoTrailingNotAllowed:
        NSLocalizedString(
          "OTO/OCO trailing orders are not allowed",
          comment: """
              Tradier API error code 'OtoOcoTrailingNotAllowed'. Trader sees this when the brokerage
              returns this code. OTO/OCO trailing orders are not allowed Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .quotePriceIsInvalid:
        NSLocalizedString(
          "There is no quote for the symbol requested, please contact"
            + "980-272-3880 to place the order.",
          comment: """
              Tradier API error code 'QuotePriceIsInvalid'. Trader sees this when the brokerage
              returns this code. There is no quote for the symbol requested, please contact
              980-272-3880 to place the order. Translators: retain phone numbers like 980-272-3880 \
            and
              keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .securityUndefined:
        NSLocalizedString(
          "Symbol does not exist. Please contact 980-272-3880 for questions or" + "concerns",
          comment: """
              Tradier API error code 'SecurityUndefined'. Trader sees this when the brokerage \
            returns
              this code. Symbol does not exist. Please contact 980-272-3880 for questions or \
            concerns
              Translators: retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, \
            OCO)
              unchanged.
            """,
        )

      case .sellShortOrderLastPriceBelow5:
        NSLocalizedString(
          "Sell Short order cannot be placed for stock priced below $5",
          comment: """
              Tradier API error code 'SellShortOrderLastPriceBelow5'. Trader sees this when the
              brokerage returns this code. Sell Short order cannot be placed for stock priced \
            below $5
              Translators: retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, \
            OCO)
              unchanged.
            """,
        )

      case .sellStopOrderStopPriceGreaterBid:
        NSLocalizedString(
          "Sell Stop order must have a Stop price less than the Bid price",
          comment: """
              Tradier API error code 'SellStopOrderStopPriceGreaterBid'. Trader sees this when the
              brokerage returns this code. Sell Stop order must have a Stop price less than the Bid
              price Translators: retain phone numbers like 980-272-3880 and keep trading acronyms
              (GTC, OCO) unchanged.
            """,
        )

      case .shortOptionTradingDeniedForAccount:
        NSLocalizedString(
          "Account is restricted for option trading. Please contact 980-272-3880"
            + "for questions or concerns",
          comment: """
              Tradier API error code 'ShortOptionTradingDeniedForAccount'. Trader sees this when the
              brokerage returns this code. Account is restricted for option trading. Please contact
              980-272-3880 for questions or concerns Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .shortOrderIsGtc:
        NSLocalizedString(
          "You cannot place short stock orders with GTC, only day orders are" + "allowed",
          comment: """
              Tradier API error code 'ShortOrderIsGtc'. Trader sees this when the brokerage returns
              this code. You cannot place short stock orders with GTC, only day orders are allowed
              Translators: retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, \
            OCO)
              unchanged.
            """,
        )

      case .shortPositionCrossZero:
        NSLocalizedString(
          "Buy order is for more shares than your current short position, please"
            + "review current position quantity along with open orders for security.",
          comment: """
              Tradier API error code 'ShortPositionCrossZero'. Trader sees this when the brokerage
              returns this code. Buy order is for more shares than your current short position, \
            please
              review current position quantity along with open orders for security. Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .shortStockTradingDeniedForAccount:
        NSLocalizedString(
          "Account is restricted from short sales. Please contact 980-272-3880"
            + "for questions or concerns",
          comment: """
              Tradier API error code 'ShortStockTradingDeniedForAccount'. Trader sees this when the
              brokerage returns this code. Account is restricted from short sales. Please contact
              980-272-3880 for questions or concerns Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .shortTradingDeniedForSecurity:
        NSLocalizedString(
          "This symbol is not available for short sales. Please contact"
            + "980-272-3880 for questions or concerns",
          comment: """
              Tradier API error code 'ShortTradingDeniedForSecurity'. Trader sees this when the
              brokerage returns this code. This symbol is not available for short sales. Please
              contact 980-272-3880 for questions or concerns Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .spreadTradingDeniedForAccount:
        NSLocalizedString(
          "Account is restricted for spread trading. Please contact 980-272-3880"
            + "for questions or concerns",
          comment: """
              Tradier API error code 'SpreadTradingDeniedForAccount'. Trader sees this when the
              brokerage returns this code. Account is restricted for spread trading. Please contact
              980-272-3880 for questions or concerns Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .stopPriceUndefined:
        NSLocalizedString(
          "Stop price is not defined",
          comment: """
              Tradier API error code 'StopPriceUndefined'. Trader sees this when the brokerage \
            returns
              this code. Stop price is not defined Translators: retain phone numbers like \
            980-272-3880
              and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .strikePriceUndefined:
        NSLocalizedString(
          "Strike price for option leg is not defined",
          comment: """
              Tradier API error code 'StrikePriceUndefined'. Trader sees this when the brokerage
              returns this code. Strike price for option leg is not defined Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .tooSmallEquityForDayTrading:
        NSLocalizedString(
          "Pattern Day Trader Rule violation: Equity balance fell below $25,000",
          comment: """
              Tradier API error code 'TooSmallEquityForDayTrading'. Trader sees this when the
              brokerage returns this code. Pattern Day Trader Rule violation: Equity balance fell
              below $25,000 Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .totalInitialMargin:
        NSLocalizedString(
          "You do not have enough buying power for this trade",
          comment: """
              Tradier API error code 'TotalInitialMargin'. Trader sees this when the brokerage \
            returns
              this code. You do not have enough buying power for this trade Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .tradeNonStandartOptions:
        NSLocalizedString(
          "You cannot place an order with non standard options",
          comment: """
              Tradier API error code 'TradeNonStandartOptions'. Trader sees this when the brokerage
              returns this code. You cannot place an order with non standard options Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .tradingDeniedForAccount:
        NSLocalizedString(
          "Account is restricted for trading. Please contact 980-272-3880 for"
            + "questions or concerns",
          comment: """
              Tradier API error code 'TradingDeniedForAccount'. Trader sees this when the brokerage
              returns this code. Account is restricted for trading. Please contact 980-272-3880 for
              questions or concerns Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .tradingDeniedForSecurity:
        NSLocalizedString(
          "This asset class is restricted for trading",
          comment: """
              Tradier API error code 'TradingDeniedForSecurity'. Trader sees this when the brokerage
              returns this code. This asset class is restricted for trading Translators: retain \
            phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedBuyOrder:
        NSLocalizedString(
          "Buy order cannot be placed to cover short position, order must be"
            + "placed as a Buy to Cover",
          comment: """
              Tradier API error code 'UnexpectedBuyOrder'. Trader sees this when the brokerage \
            returns
              this code. Buy order cannot be placed to cover short position, order must be placed \
            as a
              Buy to Cover Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedBuyOrderOption:
        NSLocalizedString(
          "Buy To Open order cannot be placed to close a short option position,"
            + "order must be placed as a Buy to Close",
          comment: """
              Tradier API error code 'UnexpectedBuyOrderOption'. Trader sees this when the brokerage
              returns this code. Buy To Open order cannot be placed to close a short option \
            position,
              order must be placed as a Buy to Close Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedBuyToCoverOrder:
        NSLocalizedString(
          "Buy To Cover order cannot be placed unless closing a short position,"
            + "please check open orders.",
          comment: """
              Tradier API error code 'UnexpectedBuyToCoverOrder'. Trader sees this when the \
            brokerage
              returns this code. Buy To Cover order cannot be placed unless closing a short \
            position,
              please check open orders. Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedBuyToCoverOrderOption:
        NSLocalizedString(
          "Buy To Close order cannot be placed unless closing a short option"
            + "position, please check open orders.",
          comment: """
              Tradier API error code 'UnexpectedBuyToCoverOrderOption'. Trader sees this when the
              brokerage returns this code. Buy To Close order cannot be placed unless closing a \
            short
              option position, please check open orders. Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedSellOrder:
        NSLocalizedString(
          "Sell order cannot be placed unless you are closing a long position,"
            + "please check open orders.",
          comment: """
              Tradier API error code 'UnexpectedSellOrder'. Trader sees this when the brokerage
              returns this code. Sell order cannot be placed unless you are closing a long position,
              please check open orders. Translators: retain phone numbers like 980-272-3880 and keep
              trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedSellOrderOption:
        NSLocalizedString(
          "Sell to Close order cannot be placed unless you are closing a long"
            + "option position, please check open orders.",
          comment: """
              Tradier API error code 'UnexpectedSellOrderOption'. Trader sees this when the \
            brokerage
              returns this code. Sell to Close order cannot be placed unless you are closing a long
              option position, please check open orders. Translators: retain phone numbers like
              980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedSellShortOrder:
        NSLocalizedString(
          "Sell short order cannot be placed while you have a current long"
            + "position, please check open orders.",
          comment: """
              Tradier API error code 'UnexpectedSellShortOrder'. Trader sees this when the brokerage
              returns this code. Sell short order cannot be placed while you have a current long
              position, please check open orders. Translators: retain phone numbers like \
            980-272-3880
              and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .unexpectedSellShortOrderOption:
        NSLocalizedString(
          "Sell to Open order cannot be placed while you have a current long"
            + "option position, please check open orders.",
          comment: """
              Tradier API error code 'UnexpectedSellShortOrderOption'. Trader sees this when the
              brokerage returns this code. Sell to Open order cannot be placed while you have a
              current long option position, please check open orders. Translators: retain phone
              numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .userDisabled:
        NSLocalizedString(
          "Account is disabled for trading. Please contact 980-272-3880 for"
            + "questions or concerns",
          comment: """
              Tradier API error code 'UserDisabled'. Trader sees this when the brokerage returns \
            this
              code. Account is disabled for trading. Please contact 980-272-3880 for questions or
              concerns Translators: retain phone numbers like 980-272-3880 and keep trading acronyms
              (GTC, OCO) unchanged.
            """,
        )

      case .washTradeAttempt:
        NSLocalizedString(
          "You are unable to place orders on the same security and same price in"
            + "different direction",
          comment: """
              Tradier API error code 'WashTradeAttempt'. Trader sees this when the brokerage returns
              this code. You are unable to place orders on the same security and same price in
              different direction Translators: retain phone numbers like 980-272-3880 and keep \
            trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .preMarketTradingUnavailable:
        NSLocalizedString(
          "Pre-market trading is currently unavailable.",
          comment: """
              Tradier API error code 'PreMarketTradingUnavailable'. Trader sees this when the
              brokerage returns this code. Pre-market trading is currently unavailable. Translators:
              retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )

      case .openingOrdersForOTCBBNotAccepted:
        NSLocalizedString(
          "Tradier Brokerage does not accept opening orders for OTC-BB and Pink"
            + "Sheet securities, please contact us at (980)-272-3880 if you have any"
            + "questions.",
          comment: """
              Tradier API error code 'OpeningOrdersForOTCBBNotAccepted'. Trader sees this when the
              brokerage returns this code. Tradier Brokerage does not accept opening orders for \
            OTC-BB
              and Pink Sheet securities, please contact us at (980)-272-3880 if you have any
              questions. Translators: retain phone numbers like 980-272-3880 and keep trading \
            acronyms
              (GTC, OCO) unchanged.
            """,
        )

      case .limitOrderRequiredDueToPriceVolatility:
        NSLocalizedString(
          "Due to price volatility a limit order must be placed.",
          comment: """
              Tradier API error code 'LimitOrderRequiredDueToPriceVolatility'. Trader sees this when
              the brokerage returns this code. Due to price volatility a limit order must be placed.
              Translators: retain phone numbers like 980-272-3880 and keep trading acronyms (GTC, \
            OCO)
              unchanged.
            """,
        )

      case .limitOrderRequiredOutsideMarketHours:
        NSLocalizedString(
          "Outside of market hours this order is required to be placed at a limit" + "price.",
          comment: """
              Tradier API error code 'LimitOrderRequiredOutsideMarketHours'. Trader sees this when \
            the
              brokerage returns this code. Outside of market hours this order is required to be \
            placed
              at a limit price. Translators: retain phone numbers like 980-272-3880 and keep trading
              acronyms (GTC, OCO) unchanged.
            """,
        )

      case .orderFailedPriceRangeAggressive:
        NSLocalizedString(
          "TradierBrokerageOrderModel failed PriceRange - AGGRESSIVE: OrderPrice {1} RefPrice {2}"
            + "Limit {3} aggressive",
          comment: """
              Tradier API error code 'OrderFailedPriceRangeAggressive'. Trader sees this when the
              brokerage returns this code. TradierBrokerageOrderModel failed PriceRange - AGGRESSIVE: OrderPrice {1}
              RefPrice {2} Limit {3} aggressive Translators: retain phone numbers like 980-272-3880
              and keep trading acronyms (GTC, OCO) unchanged.
            """,
        )
      }
    }
  }
}
