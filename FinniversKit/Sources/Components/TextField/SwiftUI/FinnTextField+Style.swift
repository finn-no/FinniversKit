//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension FinnTextField {
    enum Style {
        case `default`
        case focused
        case error

        var underlineColor: Color {
            switch self {
            case .default: return Color.textSecondary
            case .focused: return Color.accentSecondaryBlue
            case .error: return Color.textCritical
            }
        }

        var underlineHeight: CGFloat {
            switch self {
            case .focused, .error: return 2
            case .default: return 1
            }
        }

        var helpTextColor: Color {
            switch self {
            case .error: return Color.textCritical
            default: return Color.textPrimary
            }
        }
    }
}
