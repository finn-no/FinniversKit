//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension TextField {
    enum State {
        case normal
        case focus
        case disabled
        case error
        case readOnly

        var underlineHeight: CGFloat {
            switch self {
            case .normal, .disabled:
                return 1

            case .focus, .error:
                return 2

            case .readOnly:
                return 0
            }
        }

        var underlineColor: UIColor {
            switch self {
            case .normal:
                return .textSubtle

            case .disabled:
                return .textDisabled

            case .focus:
                return .accentSecondaryBlue

            case .error:
                return .textNegative

            case .readOnly:
                return .clear
            }
        }

        var textFieldBackgroundColor: UIColor {
            switch self {
            case .disabled, .readOnly:
                return .clear

            case .normal, .focus, .error:
                return .backgroundInfoSubtle
            }
        }

        var accessoryLabelTextColor: UIColor {
            switch self {
            case .disabled, .readOnly, .normal, .focus:
                return .text

            case .error:
                return .textNegative
            }
        }
    }
}
