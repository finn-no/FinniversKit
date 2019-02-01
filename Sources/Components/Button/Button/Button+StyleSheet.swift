//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension Button {
    struct StyleSheet {
        private let style: Style
        private let size: Size

        init(style: Style, size: Size) {
            self.style = style
            self.size = size
        }

        var font: UIFont {
            switch style {
            case .link: return .caption
            default: return .title4
            }
        }

        var bodyColor: UIColor {
            switch style {
            case .default, .link, .flat: return .clear
            case .callToAction: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var borderWidth: CGFloat {
            switch style {
            case .default: return 2.0
            default: return 0.0
            }
        }

        var borderColor: UIColor? {
            switch style {
            case .default: return .secondaryBlue
            default: return nil
            }
        }

        var textColor: UIColor {
            switch style {
            case .default, .link, .flat: return .primaryBlue
            default: return .milk
            }
        }

        var highlightedBodyColor: UIColor? {
            switch style {
            case .callToAction: return .callToActionButtonHighlightedBodyColor
            case .destructive: return .destructiveButtonHighlightedBodyColor
            case .default: return .defaultButtonHighlightedBodyColor
            default: return nil
            }
        }

        var highlightedBorderColor: UIColor? {
            switch style {
            case .default: return .primaryBlue
            default: return nil
            }
        }

        var highlightedTextColor: UIColor? {
            switch style {
            case .link: return .linkButtonHighlightedTextColor
            case .flat: return .flatButtonHighlightedTextColor
            default: return nil
            }
        }

        var disabledBodyColor: UIColor? {
            switch style {
            case .default, .link, .flat: return nil
            default: return .sardine
            }
        }

        var disabledBorderColor: UIColor? {
            switch style {
            case .default: return .sardine
            default: return nil
            }
        }

        var disabledTextColor: UIColor? {
            switch style {
            case .callToAction, .destructive: return nil
            default: return .sardine
            }
        }

        var margins: UIEdgeInsets {
            switch style {
            case .link: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            default: return UIEdgeInsets(top: .mediumSpacing, left: .mediumLargeSpacing, bottom: .mediumSpacing, right: .mediumLargeSpacing)
            }
        }

        var paddings: UIEdgeInsets {
            switch style {
            case .link, .flat: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            default: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            }
        }
    }
}
