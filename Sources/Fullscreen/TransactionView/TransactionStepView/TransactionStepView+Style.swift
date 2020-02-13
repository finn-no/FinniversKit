//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public extension TransactionStepView {
    enum Style {
        case notStarted
        case inProgress
        case inProgressAwaitingOtherParty
        case completed

        var backgroundColor: UIColor {
            switch self {
            case .notStarted, .completed:
                return .bgPrimary
            case .inProgress, .inProgressAwaitingOtherParty:
                return .accentToothpaste
            }
        }

        var titleStyle: Label.Style {
            switch self {
            default:
                return .title3Strong
            }
        }

        var subtitleStyle: Label.Style {
            switch self {
            default:
                return .caption
            }
        }

        var actionButtonStyle: Button.Style {
            switch self {
            case .notStarted, .inProgress:
                return .callToAction
            case .inProgressAwaitingOtherParty:
                return .default
            case .completed:
                return .link
            }
        }

        var actionButtonSize: Button.Size {
            switch self {
            case .inProgress, .inProgressAwaitingOtherParty:
                return .normal
            case .notStarted, .completed:
                return .small
            }
        }

        var actionButtonIsEnabled: Bool {
            switch self {
            case .notStarted:
                return false
            case .inProgress, .inProgressAwaitingOtherParty, .completed:
                return true
            }
        }

        var detailStyle: Label.Style {
            switch self {
            default:
                return .detail
            }
        }
    }
}
