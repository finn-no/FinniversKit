//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public enum TransactionActionButton: String {
    case `default` = "DEFAULT"
    case flat = "FLAT"
    case callToAction = "CALL_TO_ACTION"
    case republishAd = "REPUBLISH_AD"

    public init(rawValue: String) {
        switch rawValue {
        case "DEFAULT":
            self = .default
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

extension TransactionActionButton {
    public enum Action: String {
        // Native actions
        case seeAd = "SEE_AD"
        case republishAd = "REPUBLISH_AD"

        // Navigate to web
        case url = "URL"
        case fallback = "FALLBACK"

        public init(rawValue: String) {
            switch rawValue {
            case "URL":
                self = .url
            case "SEE_AD":
                self = .seeAd
            case "REPUBLISH_AD":
                self = .republishAd
            default:
                self = .fallback
            }
        }
    }
}
