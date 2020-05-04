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

        public var titleTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            default:
                return .textPrimary
            }
        }

        public var mainTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            default:
                return .textPrimary
            }
        }

        public var detailTextColor: UIColor {
            switch self {
            case .notStarted:
                return .textSecondary
            default:
                return .textPrimary
            }
        }
    }
}
