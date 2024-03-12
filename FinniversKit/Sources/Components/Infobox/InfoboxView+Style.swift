//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import SwiftUI

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
                return .body
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

        var secondaryButtonStyle: Button.Style {
            switch self {
            case .small:
                return .flat
            case .normal:
                return .link
            default:
                return .default
            }
        }

        var secondaryButtonSize: Button.Size {
            switch self {
            case .small:
                return .small
            case .normal:
                return .normal
            default:
                return .normal
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .small(let backgroundColor):
                return backgroundColor
            case .normal(let backgroundColor, _):
                return backgroundColor
            case .warning:
                return .backgroundWarningSubtle
            }
        }

        var textColor: UIColor {
            switch self {
            case .small:
                return .text
            case .normal:
                return .text
            case .warning:
                return .text
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

struct PrimaryButtonStyleModifier: ViewModifier {
    let style: InfoboxView.Style
    func body(content: Content) -> some View {
        switch style {
        case .small:
            content.buttonStyle(DefaultStyle())
        case .normal:
            content.buttonStyle(CallToAction())
        case .warning:
            content.buttonStyle(FlatStyle())
        }
    }
}

extension View {
    func primaryButtonStyle(for style: InfoboxView.Style) -> some View {
        self.modifier(PrimaryButtonStyleModifier(style: style))
    }
}

struct SecondaryButtonStyleModifier: ViewModifier {
    let style: InfoboxView.Style
    func body(content: Content) -> some View {
        switch style {
        case .small:
            content.buttonStyle(FlatStyle())
        case .normal:
            content.buttonStyle(InlineFlatStyle())
        default:
            content.buttonStyle(DefaultStyle())
        }
    }
}

extension View {
    func secondaryButtonStyle(for style: InfoboxView.Style) -> some View {
        self.modifier(SecondaryButtonStyleModifier(style: style))
    }
}
