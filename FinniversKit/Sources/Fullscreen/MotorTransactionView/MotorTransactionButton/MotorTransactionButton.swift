//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public enum MotorTransactionButton: String {
    case flat = "FLAT"
    case callToAction = "CALL_TO_ACTION"
    case disabled = "DISABLED"
    case `default` = "DEFAULT"

    public init(rawValue: String) {
        switch rawValue {
        case "FLAT":
            self = .flat
        case "CALL_TO_ACTION":
            self = .callToAction
        case "DISABLED":
            self = .disabled
        default:
            self = .default
        }
    }

    var style: Button.Style {
        switch self {
        case .flat:
            return .flat
        case .callToAction:
            return .callToAction
        case .disabled:
            return .callToAction
        case .default:
            return .default
        }
    }

    var isEnabled: Bool {
        if self == .disabled {
            return false
        }
        return true
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

        // Re-register
        case reregister = "REREGISTER"
        case resetOwnershipTransfer = "RESET_OWNERSHIP_TRANSFER"

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
            case "REREGISTER":
                self = .reregister
            case "RESET_OWNERSHIP_TRANSFER":
                self = .resetOwnershipTransfer
            case "URL":
                self = .url
            default:
                self = .fallback
            }
        }
    }
}
