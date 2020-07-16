//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

extension MotorTransactionStepView {
    /// Styling provided by the backend
    public enum CustomStyle: String {
        case warning = "WARNING"
        case error = "ERROR"
        case `default` = "DEFAULT"

        public init(rawValue: String) {
            switch rawValue {
            case "WARNING":
                self = .warning
            case "ERROR":
                self = .error
            default:
                self = .default
            }
        }

        /// Use custom style provided by the backend or fallback to the style defined locally
        public func backgroundColor(style: MotorTransactionStepView.Style) -> UIColor {
            switch self {
            case .error:
                return .bgCritical
            case .warning:
                return .bgAlert
            case .default:
                return style.backgroundColor
            }
        }
    }
}
