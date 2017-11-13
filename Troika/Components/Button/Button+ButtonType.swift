//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Button {

    public enum ButtonType {
        case normal // default
        case flat
        case destructive

        var bodyColor: UIColor {
            switch self {
            case .normal: return .milk
            case .flat: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .normal: return 2.0
            default: return 0.0
            }
        }

        var borderColor: UIColor {
            switch self {
            case .normal: return .secondaryBlue
            case .flat: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var textColor: UIColor {
            switch self {
            case .normal: return .primaryBlue
            default: return .milk
            }
        }
    }
}
