//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public extension TransactionStepView {
    enum Style {
        case notStarted
        case active
        case completed

        public var backgroundColor: UIColor {
            switch self {
            case .notStarted, .completed:
                return .bgPrimary
            case .active:
                return .bgSecondary
            }
        }

        public var cornerRadius: CGFloat {
            switch self {
            case .notStarted:
                return 0.0
            default:
                return .spacingS
            }
        }

        public var titleFont: UIFont {
            switch self {
            default:
                return .title3Strong
            }
        }

        public var titleTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            default:
                return .textPrimary
            }
        }

        public var bodyFont: UIFont {
            switch self {
            default:
                return .body
            }
        }

        public var bodyTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            case .active, .completed:
                return .textPrimary
            }
        }

        public var detailFont: UIFont {
            switch self {
            default:
                return .caption
            }
        }

        public var detailTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            case .active, .completed:
                return .textPrimary
            }
        }

        public var actionButtonEnabled: Bool {
            switch self {
            case .notStarted:
                return false
            case .active, .completed:
                return true
            }
        }
    }
}
