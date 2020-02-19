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
                return .ice
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .notStarted:
                return 0.0
            default:
                return .mediumSpacing
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
                return .stone
            default:
                return .licorice
            }
        }

        var subtitleFont: UIFont {
            switch self {
            default:
                return .body
            }
        }

        var subtitleTextColor: UIColor {
            switch self {
            case .notStarted:
                return .stone
            case .inProgress, .inProgressAwaitingOtherParty, .completed:
                return .licorice
            }
        }

        var actionButtonStyle: Button.Style {
            switch self {
            case .notStarted, .inProgress:
                return .callToAction
            case .inProgressAwaitingOtherParty:
                return .default
            case .completed:
                return .flat
            }
        }

        var actionButtonSize: Button.Size {
            switch self {
            default:
                return .normal
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

        var detailFont: UIFont {
            switch self {
            default:
                return .caption
            }
        }

        var detailTextColor: UIColor {
            switch self {
            case .notStarted:
                return .stone
            case .inProgress, .inProgressAwaitingOtherParty, .completed:
                return .licorice
            }
        }
    }
}
