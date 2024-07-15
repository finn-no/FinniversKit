//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Warp

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
            case .default: return Warp.UIColor.badgeNeutralBackground
            case .success: return Warp.UIColor.badgePositiveBackground
            case .warning: return Warp.UIColor.badgeWarningBackground
            case .error: return Warp.UIColor.badgeNegativeBackground
            case .disabled: return Warp.UIColor.badgeDisabledBackground
            case .sponsored: return Warp.UIColor.badgeSponsoredBackground
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
