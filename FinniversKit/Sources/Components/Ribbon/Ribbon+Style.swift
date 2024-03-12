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
            case .default: return warpUIColor.badgeNeutralBackground
            case .success: return warpUIColor.badgePositiveBackground
            case .warning: return warpUIColor.badgeWarningBackground
            case .error: return warpUIColor.badgeNegativeBackground
            case .disabled: return warpUIColor.badgeDisabledBackground
            case .sponsored: return warpUIColor.badgeSponsoredBackground
            }
        }

        var textColor: UIColor {
            switch self {
            case .default, .disabled: return .text
            default: return .text
            }
        }
    }
}
