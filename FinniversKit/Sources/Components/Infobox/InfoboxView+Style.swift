//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension InfoboxView {
    enum Style {
        case small(backgroundColor: UIColor)
        case normal(backgroundColor: UIColor, primaryButtonIcon: UIImage?)
        case warning

        var titleStyle: Label.Style {
            switch self {
            case .small:
                return .bodyStrong
            case .normal:
                return .title3
            case .warning:
                return .bodyStrong
            }
        }

        var detailStyle: Label.Style {
            switch self {
            case .small:
                return .caption
            case .normal:
                return .caption
            case .warning:
                return .caption
            }
        }

        var primaryButtonStyle: Button.Style {
            switch self {
            case .small:
                return .default
            case .normal:
                return .callToAction
            case .warning:
                return .flat
            }
        }

        var primaryButtonSize: Button.Size {
            switch self {
            case .small:
                return .small
            case .normal:
                return .normal
            case .warning:
                return .normal
            }
        }

        var secondaryButtonStyle: Button.Style? {
            switch self {
            case .small:
                return .flat
            case .normal:
                return .link
            default:
                return nil
            }
        }

        var secondaryButtonSize: Button.Size? {
            switch self {
            case .small:
                return .small
            case .normal:
                return .normal
            default:
                return nil
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .small(let backgroundColor):
                return backgroundColor
            case .normal(let backgroundColor, _):
                return backgroundColor
            case .warning:
                return .banana
            }
        }

        var primaryButtonIcon: UIImage? {
            switch self {
            case .small:
                return nil
            case .normal(_, let image):
                return image
            case .warning:
                return nil
            }
        }
    }
}
