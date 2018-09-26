//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension TextField {
    public enum State {
        case normal
        case focus
        case disabled
        case error
        case readOnly

        var borderWidth: CGFloat {
            switch self {
            case .normal, .disabled:
                return 0.5

            case .focus, .error:
                return 1.5

            case .readOnly:
                return 0
            }
        }

        var borderColor: UIColor {
            switch self {
            case .normal:
                return .sardine

            case .disabled:
                return .sardine

            case .focus:
                return .secondaryBlue

            case .error:
                return .cherry

            case .readOnly:
                return .clear
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .disabled, .readOnly:
                return .clear

            case .normal, .focus, .error:
                return .ice
            }
        }

        var accessoryLabelTextColor: UIColor {
            switch self {
            case .disabled, .readOnly, .normal, .focus:
                return .licorice

            case .error:
                return .cherry
            }
        }
    }
}
