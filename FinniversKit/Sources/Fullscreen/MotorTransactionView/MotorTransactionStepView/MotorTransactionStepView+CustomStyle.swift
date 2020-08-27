//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

extension MotorTransactionStepView {
    /// Styling provided by the backend
    public enum CustomStyle: String {
        case warning = "WARNING"
        case error = "ERROR"
        case focus = "FOCUS"
        /// Fallback to use styling that is defined in the MotorTransactionStepView.Style enum
        case `default` = "DEFAULT"

        public init(rawValue: String) {
            switch rawValue {
            case "WARNING":
                self = .warning
            case "ERROR":
                self = .error
            case "FOCUS":
                self = .focus
            default:
                self = .default
            }
        }

        public func backgroundColor(style: MotorTransactionStepView.Style) -> UIColor {
            switch self {
            case .error:
                return .bgCritical
            case .warning:
                return .bgAlert
            case .focus:
                return .bgSecondary
            case .default:
                return style.backgroundColor
            }
        }
    }
}
