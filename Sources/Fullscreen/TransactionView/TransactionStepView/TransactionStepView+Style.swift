//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public extension TransactionStepView {
    enum Style {
        case notStarted
        case active
        case completed

        var backgroundColor: UIColor {
            switch self {
            case .notStarted, .completed:
                return .bgPrimary
            case .active:
                return .bgSecondary
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .notStarted:
                return 0.0
            default:
                return .spacingS
            }
        }

        var titleFont: UIFont {
            switch self {
            default:
                return .title3Strong
            }
        }

        var titleTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            default:
                return .textPrimary
            }
        }

        var bodyFont: UIFont {
            switch self {
            default:
                return .body
            }
        }

        var bodyTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            case .active, .completed:
                return .textPrimary
            }
        }

        var detailFont: UIFont {
            switch self {
            default:
                return .caption
            }
        }

        var detailTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            case .active, .completed:
                return .textPrimary
            }
        }

        var actionButtonEnabled: Bool {
            switch self {
            case .notStarted:
                return false
            case .active, .completed:
                return true
            }
        }
    }
}

public extension TransactionStepView {
    enum PrimaryButton: String {
        case `default` = "default"
        case flat = "flat"
        case callToAction = "call_to_action"

        public init(rawValue: String) {
            switch rawValue {
            case "default":
                self = .default
            case "flat":
                self = .flat
            case "call_to_action":
                self = .callToAction
            default:
                fatalError("ActionButton style \(rawValue) is not supported")
            }
        }

        var style: Button.Style {
            switch self {
            case .default:
                return .default
            case .callToAction:
                return .callToAction
            case .flat:
                return .flat
            }
        }
    }
}

public extension TransactionStepView.PrimaryButton {
    enum Action: String {
        case url = "url"
        case seeAd = "see_ad"
        case unknown

        public init(rawValue: String) {
            switch rawValue {
            case "url":
                self = .url
            case "see_ad":
                self = .seeAd
            default:
                self = .unknown
            }
        }
    }
}
