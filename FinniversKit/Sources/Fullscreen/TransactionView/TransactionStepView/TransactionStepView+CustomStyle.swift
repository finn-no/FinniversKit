//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

extension TransactionStepView {
    /// Styling provided by the backend
    public enum CustomStyle: String {
        case warning
        case error

        public var backgroundColor: UIColor {
            switch self {
            case .error:
                return .bgCritical
            case .warning:
                return .bgAlert
            }
        }
    }
}
