//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Button {
    enum Size {
        case normal
        case small
    }

    /// Convenience grouping of button state related properties
    struct StateStyle: Equatable {
        let textColor: UIColor?
        let backgroundColor: UIColor?
        let borderColor: UIColor?
    }

    struct Style: Equatable {
        let bodyColor: UIColor
        let borderWidth: CGFloat
        let borderColor: UIColor?
        let textColor: UIColor
        let highlightedBodyColor: UIColor?
        let highlightedBorderColor: UIColor?
        let highlightedTextColor: UIColor?
        let disabledBodyColor: UIColor?
        let disabledBorderColor: UIColor?
        let disabledTextColor: UIColor?
        let margins: UIEdgeInsets
        let smallFont: UIFont
        let normalFont: UIFont

        init(
            bodyColor: UIColor,
            borderWidth: CGFloat,
            borderColor: UIColor?,
            textColor: UIColor,
            highlightedBodyColor: UIColor?,
            highlightedBorderColor: UIColor?,
            highlightedTextColor: UIColor?,
            disabledBodyColor: UIColor?,
            disabledBorderColor: UIColor?,
            disabledTextColor: UIColor?,
            margins: UIEdgeInsets = UIEdgeInsets(
                vertical: .mediumSpacing,
                horizontal: .mediumLargeSpacing
            ),
            smallFont: UIFont = .detailStrong,
            normalFont: UIFont = .bodyStrong
        ) {
            self.bodyColor = bodyColor
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.textColor = textColor
            self.highlightedBodyColor = highlightedBodyColor
            self.highlightedBorderColor = highlightedBorderColor
            self.highlightedTextColor = highlightedTextColor
            self.disabledBodyColor = disabledBodyColor
            self.disabledBorderColor = disabledBorderColor
            self.disabledTextColor = disabledTextColor
            self.margins = margins
            self.smallFont = smallFont
            self.normalFont = normalFont
        }

        init(
            borderWidth: CGFloat,
            stateStyles: [UIControl.State: StateStyle],
            margins: UIEdgeInsets = UIEdgeInsets(
                vertical: .mediumSpacing,
                horizontal: .mediumLargeSpacing
            ),
            smallFont: UIFont = .detailStrong,
            normalFont: UIFont = .bodyStrong
        ) {
            self.borderWidth = borderWidth

            self.bodyColor = stateStyles[.normal]?.backgroundColor ?? .bgPrimary
            self.borderColor = stateStyles[.normal]?.borderColor
            self.textColor = stateStyles[.normal]?.textColor ?? .textAction

            self.highlightedBodyColor = stateStyles[.highlighted]?.backgroundColor
            self.highlightedBorderColor = stateStyles[.highlighted]?.borderColor
            self.highlightedTextColor = stateStyles[.highlighted]?.textColor

            self.disabledBodyColor = stateStyles[.disabled]?.backgroundColor
            self.disabledBorderColor = stateStyles[.disabled]?.borderColor
            self.disabledTextColor = stateStyles[.disabled]?.textColor

            self.margins = margins
            self.smallFont = smallFont
            self.normalFont = normalFont
        }

        func backgroundColor(forState state: UIControl.State) -> UIColor? {
            switch state {
            case .highlighted:
                return highlightedBodyColor
            case .disabled:
                return disabledBodyColor
            default:
                return bodyColor
            }
        }

        func borderColor(forState state: UIControl.State) -> CGColor? {
            switch state {
            case .highlighted:
                return highlightedBorderColor?.cgColor
            case .disabled:
                return disabledBorderColor?.cgColor
            default:
                return borderColor?.cgColor
            }
        }

        /// Given an existing style, this helps to create a new one overriding some of the values of the original style
        /// This method is intended for styles for concrete cases rather than default styles like `callToAction`
        func overrideStyle(
            bodyColor: UIColor? = nil,
            borderWidth: CGFloat? = nil,
            borderColor: UIColor? = nil,
            textColor: UIColor? = nil,
            highlightedBodyColor: UIColor? = nil,
            highlightedBorderColor: UIColor? = nil,
            highlightedTextColor: UIColor? = nil,
            disabledBodyColor: UIColor? = nil,
            disabledBorderColor: UIColor? = nil,
            disabledTextColor: UIColor? = nil,
            margins: UIEdgeInsets? = nil,
            smallFont: UIFont? = nil,
            normalFont: UIFont? = nil
        ) -> Style {
            Style(
                bodyColor: bodyColor ?? self.bodyColor,
                borderWidth: borderWidth ?? self.borderWidth,
                borderColor: borderColor ?? self.borderColor,
                textColor: textColor ?? self.textColor,
                highlightedBodyColor: highlightedBodyColor ?? self.highlightedBodyColor,
                highlightedBorderColor: highlightedBorderColor ?? self.highlightedBorderColor,
                highlightedTextColor: highlightedTextColor ?? self.highlightedTextColor,
                disabledBodyColor: disabledBodyColor ?? self.disabledBodyColor,
                disabledBorderColor: disabledBorderColor ?? self.disabledBorderColor,
                disabledTextColor: disabledTextColor ?? self.disabledTextColor,
                margins: margins ?? self.margins,
                smallFont: smallFont ?? self.smallFont,
                normalFont: normalFont ?? self.normalFont
            )
        }

        // MARK: - Size dependant methods

        func paddings(forSize size: Size) -> UIEdgeInsets {
            switch size {
            case .normal: return UIEdgeInsets(vertical: .smallSpacing, horizontal: 0)
            case .small: return .zero
            }
        }

        func font(forSize size: Size) -> UIFont {
            switch size {
            case .normal: return normalFont
            case .small: return smallFont
            }
        }
    }
}

// MARK: - Styles
public extension Button.Style {
    static let `default` = Button.Style(
        borderWidth: 2.0,
        stateStyles: [
            .normal: Button.StateStyle(
                textColor: .textAction,
                backgroundColor: .bgPrimary,
                borderColor: .accentSecondaryBlue
            ),
            .highlighted: Button.StateStyle(
                textColor: nil,
                backgroundColor: .defaultButtonHighlightedBodyColor,
                borderColor: .btnPrimary
            ),
            .disabled: Button.StateStyle(
                textColor: .textDisabled,
                backgroundColor: nil,
                borderColor: .btnDisabled
            )
        ]
    )

    static let callToAction = Button.Style(
        borderWidth: 0.0,
        stateStyles: [
            .normal: Button.StateStyle(
                textColor: .textTertiary,
                backgroundColor: .btnPrimary,
                borderColor: nil
            ),
            .highlighted: Button.StateStyle(
                textColor: nil,
                backgroundColor: .callToActionButtonHighlightedBodyColor,
                borderColor: nil
            ),
            .disabled: Button.StateStyle(
                textColor: nil,
                backgroundColor: .btnDisabled,
                borderColor: nil
            )
        ]
    )

    static let destructive = Button.Style(
        borderWidth: 0.0,
        stateStyles: [
            .normal: Button.StateStyle(
                textColor: .textTertiary,
                backgroundColor: .btnCritical,
                borderColor: nil
            ),
            .highlighted: Button.StateStyle(
                textColor: nil,
                backgroundColor: .destructiveButtonHighlightedBodyColor,
                borderColor: nil
            ),
            .disabled: Button.StateStyle(
                textColor: nil,
                backgroundColor: .btnDisabled,
                borderColor: nil
            )
        ]
    )

    static let flat = Button.Style(
        borderWidth: 0.0,
        stateStyles: [
            .normal: Button.StateStyle(
                textColor: .textAction,
                backgroundColor: .clear,
                borderColor: nil
            ),
            .highlighted: Button.StateStyle(
                textColor: .flatButtonHighlightedTextColor,
                backgroundColor: nil,
                borderColor: nil
            ),
            .disabled: Button.StateStyle(
                textColor: .textDisabled,
                backgroundColor: nil,
                borderColor: nil
            )
        ]
    )

    static let destructiveFlat = Button.Style(
        borderWidth: 0.0,
        stateStyles: [
            .normal: Button.StateStyle(
                textColor: .textCritical,
                backgroundColor: .clear,
                borderColor: nil
            ),
            .highlighted: Button.StateStyle(
                textColor: .destructiveFlatButtonHighlightedTextColor,
                backgroundColor: nil,
                borderColor: nil
            ),
            .disabled: Button.StateStyle(
                textColor: .textDisabled,
                backgroundColor: nil,
                borderColor: nil
            ),
        ],
        smallFont: .detailStrong,
        normalFont: .detailStrong
    )

    static let link = Button.Style(
        borderWidth: 0.0,
        stateStyles: [
            .normal: Button.StateStyle(
                textColor: .textAction,
                backgroundColor: .clear,
                borderColor: nil
            ),
            .highlighted: Button.StateStyle(
                textColor: .linkButtonHighlightedTextColor,
                backgroundColor: nil,
                borderColor: nil
            ),
            .disabled: Button.StateStyle(
                textColor: .textDisabled,
                backgroundColor: nil,
                borderColor: nil
            ),
        ],
        margins: UIEdgeInsets(
            vertical: .smallSpacing,
            horizontal: 0
        ),
        smallFont: .detail,
        normalFont: .caption
    )
}

extension UIControl.State: Hashable {}
