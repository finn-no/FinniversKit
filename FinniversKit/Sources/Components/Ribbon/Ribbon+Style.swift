//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension RibbonView {
    enum Style: Hashable {
        case `default`
        case success
        case warning
        case error
        case disabled
        case sponsored

        var color: UIColor {
            switch self {
            case .default: return .backgroundInfoSubtle
            case .success: return .bgSuccess
            case .warning: return .backgroundWarningSubtle
            case .error: return .bgCritical
            case .disabled: return .decorationSubtle
            case .sponsored: return .accentToothpaste
            }
        }

        var textColor: UIColor {
            switch self {
            case .default, .disabled: return .textPrimary
            default: return .textToast
            }
        }
    }
}
