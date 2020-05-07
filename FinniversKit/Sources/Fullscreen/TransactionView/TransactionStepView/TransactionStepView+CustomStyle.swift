//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

extension TransactionStepView {
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

        public var backgroundColor: UIColor {
            switch self {
            case .error:
                return .bgCritical
            case .warning:
                return .bgAlert
            case .default:
                return .bgPrimary
            }
        }
    }
}
