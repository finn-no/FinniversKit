//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Button {
    public enum Style {
        case `default`
        case callToAction
        case destructive
        case flat
        case link

        var font: UIFont {
            switch self {
            case .link: return .detail
            default: return .title4
            }
        }

        var bodyColor: UIColor {
            switch self {
            case .default, .link, .flat: return .milk
            case .callToAction: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .default: return 2.0
            default: return 0.0
            }
        }

        var borderColor: UIColor? {
            switch self {
            case .default: return .secondaryBlue
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            case .default, .link, .flat: return .primaryBlue
            default: return .milk
            }
        }

        var highlightedBodyColor: UIColor? {
            switch self {
            case .callToAction: return .callToActionButtonHighlightedBodyColor
            case .destructive: return .destructiveButtonHighlightedBodyColor
            case .default: return .defaultButtonHighlightedBodyColor
            default: return nil
            }
        }

        var highlightedBorderColor: UIColor? {
            switch self {
            case .default: return .primaryBlue
            default: return nil
            }
        }

        var highlightedTextColor: UIColor? {
            switch self {
            case .link: return .linkButtonHighlightedTextColor
            case .flat: return .flatButtonHighlightedTextColor
            default: return nil
            }
        }

        var disabledBodyColor: UIColor? {
            switch self {
            case .default, .link, .flat: return nil
            default: return .sardine
            }
        }

        var disabledBorderColor: UIColor? {
            switch self {
            case .default: return .sardine
            default: return nil
            }
        }

        var disabledTextColor: UIColor? {
            switch self {
            case .callToAction, .destructive: return nil
            default: return .sardine
            }
        }

        var margins: UIEdgeInsets {
            switch self {
            case .link, .flat: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            default: return UIEdgeInsets(top: .mediumSpacing, left: .mediumSpacing, bottom: .mediumSpacing, right: .mediumSpacing)
            }
        }
    }
}
