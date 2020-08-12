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
        /// will use the styling that is defined localy
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

        /// Use the custom style provided by the backend
        /// if the style does not exist, it will fallback  to the default styling defined locally
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
