//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension InfoboxView {
    public enum Style {
        case small(backgroundColor: UIColor)
        case normal(backgroundColor: UIColor, primaryButtonIcon: UIImage?)

        var titleStyle: Label.Style {
            switch self {
            case .small:
                return .bodyStrong
            case .normal:
                return .title3
            }
        }

        var detailStyle: Label.Style {
            switch self {
            case .small:
                return .caption
            case .normal:
                return .caption
            }
        }

        var primaryButtonStyle: Button.Style {
            switch self {
            case .small:
                return .default
            case .normal:
                return .callToAction
            }
        }

        var primaryButtonSize: Button.Size {
            switch self {
            case .small:
                return .small
            case .normal:
                return .normal
            }
        }

        var secondaryButtonStyle: Button.Style {
            switch self {
            case .small:
                return .flat
            case .normal:
                return .link
            }
        }

        var secondaryButtonSize: Button.Size {
            switch self {
            case .small:
                return .small
            case .normal:
                return .normal
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .small(let backgroundColor):
                return backgroundColor
            case .normal(let backgroundColor, _):
                return backgroundColor
            }
        }

        var primaryButtonIcon: UIImage? {
            switch self {
            case .small:
                return nil
            case .normal(_, let image):
                return image
            }
        }
    }
}
