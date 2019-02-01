//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Button {
    // swiftlint:disable nesting
    public struct Style {
        public enum Kind {
            case `default`
            case callToAction
            case destructive
            case flat
            case link
        }

        public enum Size {
            case normal
            case small
        }

        public let kind: Kind
        public let size: Size

        public init(_ kind: Kind, size: Size) {
            self.kind = kind
            self.size = size
        }

        var font: UIFont {
            switch kind {
            case .link: return .caption
            default: return .title4
            }
        }

        var bodyColor: UIColor {
            switch kind {
            case .default, .link, .flat: return .clear
            case .callToAction: return .primaryBlue
            case .destructive: return .cherry
            }
        }

        var borderWidth: CGFloat {
            switch kind {
            case .default: return 2.0
            default: return 0.0
            }
        }

        var borderColor: UIColor? {
            switch kind {
            case .default: return .secondaryBlue
            default: return nil
            }
        }

        var textColor: UIColor {
            switch kind {
            case .default, .link, .flat: return .primaryBlue
            default: return .milk
            }
        }

        var highlightedBodyColor: UIColor? {
            switch kind {
            case .callToAction: return .callToActionButtonHighlightedBodyColor
            case .destructive: return .destructiveButtonHighlightedBodyColor
            case .default: return .defaultButtonHighlightedBodyColor
            default: return nil
            }
        }

        var highlightedBorderColor: UIColor? {
            switch kind {
            case .default: return .primaryBlue
            default: return nil
            }
        }

        var highlightedTextColor: UIColor? {
            switch kind {
            case .link: return .linkButtonHighlightedTextColor
            case .flat: return .flatButtonHighlightedTextColor
            default: return nil
            }
        }

        var disabledBodyColor: UIColor? {
            switch kind {
            case .default, .link, .flat: return nil
            default: return .sardine
            }
        }

        var disabledBorderColor: UIColor? {
            switch kind {
            case .default: return .sardine
            default: return nil
            }
        }

        var disabledTextColor: UIColor? {
            switch kind {
            case .callToAction, .destructive: return nil
            default: return .sardine
            }
        }

        var margins: UIEdgeInsets {
            switch kind {
            case .link: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            default: return UIEdgeInsets(top: .mediumSpacing, left: .mediumLargeSpacing, bottom: .mediumSpacing, right: .mediumLargeSpacing)
            }
        }

        var paddings: UIEdgeInsets {
            switch kind {
            case .link, .flat: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            default: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            }
        }
    }
}
