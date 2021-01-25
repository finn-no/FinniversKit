//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public enum MotorTransactionButton: String {
    case flat = "FLAT"
    case callToAction = "CALL_TO_ACTION"
    case republishAd = "REPUBLISH_AD"
    case `default` = "DEFAULT"

    public init(rawValue: String) {
        switch rawValue {
        case "FLAT":
            self = .flat
        case "CALL_TO_ACTION":
            self = .callToAction
        case "REPUBLISH_AD":
            self = .republishAd
        default:
            self = .default
        }
    }

    var style: Button.Style {
        switch self {
        case .default:
            return .default
        case .callToAction, .republishAd:
            return .callToAction
        case .flat:
            return .flat
        }
    }
}

extension MotorTransactionButton {
    public enum Tag: Int {
        /// Native meaning that the button is just an inline link refering to some content on an external website.
        case native = 1

        /// Primary meaning that the button is part of the actual transaction flow
        case primary = 2
    }
}

extension MotorTransactionButton {
    public enum Action: String {
        // Native
        case seeAd = "SEE_AD"
        case republishAd = "REPUBLISH_AD"

        // Insurance
        case confirmInsurance = "CONFIRM_INSURANCE"
        case purchaseInsurance = "PURCHASE_INSURANCE"

        // Web
        case url = "URL"
        case fallback = "FALLBACK"

        public init(rawValue: String) {
            switch rawValue {
            case "SEE_AD":
                self = .seeAd
            case "REPUBLISH_AD":
                self = .republishAd
            case "CONFIRM_INSURANCE":
                self = .confirmInsurance
            case "PURCHASE_INSURANCE":
                self = .purchaseInsurance
            case "URL":
                self = .url
            default:
                self = .fallback
            }
        }
    }
}
