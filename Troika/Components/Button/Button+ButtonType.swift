//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Button {

    public enum ButtonType {
        case normal // default
        case flat
        case destructive
        case link

        var bodyColor: UIColor {
            switch self {
            case .normal, .link: return .milk
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

        var borderColor: UIColor? {
            switch self {
            case .normal: return .secondaryBlue
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            case .normal, .link: return .primaryBlue
            default: return .milk
            }
        }
    }
}
