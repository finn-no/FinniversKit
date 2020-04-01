//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public extension TransactionStepView {
    enum ActionButton: String {
        case `default` = "default"
        case flat = "flat"
        case callToAction = "call_to_action"
        case republishAd = "republish_ad"

        public init(rawValue: String) {
            switch rawValue {
            case "default":
                self = .default
            case "flat":
                self = .flat
            case "call_to_action":
                self = .callToAction
            case "republish_ad":
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
}

public extension TransactionStepView.ActionButton {
    enum Action: String {
        // Native actions
        case seeAd = "see_ad"
        case republishAd = "republish_ad"

        // Navigate to web
        case url = "url"
        case none

        public init(rawValue: String) {
            switch rawValue {
            case "url":
                self = .url
            case "see_ad":
                self = .seeAd
            case "republish_ad":
                self = .republishAd
            default:
                self = .none
            }
        }
    }
}
