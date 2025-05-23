//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Warp

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
        let smallFont: Warp.Typography
        let normalFont: Warp.Typography

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
                vertical: Warp.Spacing.spacing100,
                horizontal: Warp.Spacing.spacing200
            ),
            smallFont: Warp.Typography = .detailStrong,
            normalFont: Warp.Typography = .bodyStrong
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
                vertical: Warp.Spacing.spacing100,
                horizontal: Warp.Spacing.spacing200
            ),
            smallFont: Warp.Typography = .detailStrong,
            normalFont: Warp.Typography = .bodyStrong
        ) {
            self.borderWidth = borderWidth

            self.bodyColor = stateStyles[.normal]?.backgroundColor ?? .background
            self.borderColor = stateStyles[.normal]?.borderColor
            self.textColor = stateStyles[.normal]?.textColor ?? .textLink

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
        public func overrideStyle(
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
            smallFont: Warp.Typography? = nil,
            normalFont: Warp.Typography? = nil
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
            case .normal: return UIEdgeInsets(vertical: Warp.Spacing.spacing50, horizontal: 0)
            case .small: return .zero
            }
        }

        func font(forSize size: Size) -> UIFont {
            switch size {
            case .normal: return normalFont.uiFont
            case .small: return smallFont.uiFont
            }
        }
    }
}

// MARK: - Styles
public extension Button.Style {
    static var `default`: Button.Style {
        Button.Style(
            borderWidth: 2.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .textLink,
                    backgroundColor: .background,
                    borderColor: .border
                ),
                .highlighted: Button.StateStyle(
                    textColor: nil,
                    backgroundColor: .backgroundActive,
                    borderColor: .borderActive
                ),
                .disabled: Button.StateStyle(
                    textColor: .textDisabled,
                    backgroundColor: nil,
                    borderColor: .borderDisabled
                )
            ]
        )
    }

    static var utility: Button.Style {
        Button.Style(
            borderWidth: 1.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .text,
                    backgroundColor: .background,
                    borderColor: .border
                ),
                .highlighted: Button.StateStyle(
                    textColor: .text,
                    backgroundColor: .background,
                    borderColor: .borderActive
                ),
                .disabled: Button.StateStyle(
                    textColor: .textDisabled,
                    backgroundColor: nil,
                    borderColor: .borderDisabled
                )
            ]
        )
    }

    static var callToAction: Button.Style {
        Button.Style(
            borderWidth: 0.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .textInverted,
                    backgroundColor: Warp.UIColor.buttonPrimaryBackground,
                    borderColor: nil
                ),
                .highlighted: Button.StateStyle(
                    textColor: nil,
                    backgroundColor: Warp.UIColor.buttonPrimaryBackgroundActive,
                    borderColor: nil
                ),
                .disabled: Button.StateStyle(
                    textColor: nil,
                    backgroundColor: .backgroundDisabled,
                    borderColor: nil
                )
            ]
        )
    }

    static var destructive: Button.Style {
        Button.Style(
            borderWidth: 0.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .textInverted,
                    backgroundColor: .backgroundNegative,
                    borderColor: nil
                ),
                .highlighted: Button.StateStyle(
                    textColor: nil,
                    backgroundColor: .backgroundNegativeActive,
                    borderColor: nil
                ),
                .disabled: Button.StateStyle(
                    textColor: nil,
                    backgroundColor: .backgroundDisabled,
                    borderColor: nil
                )
            ]
        )
    }

    static var flat: Button.Style {
        Button.Style(
            borderWidth: 0.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .textLink,
                    backgroundColor: .clear,
                    borderColor: nil
                ),
                .highlighted: Button.StateStyle(
                    textColor: .text,
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
    }

    static var destructiveFlat: Button.Style {
        Button.Style(
            borderWidth: 0.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .textNegative,
                    backgroundColor: .clear,
                    borderColor: nil
                ),
                .highlighted: Button.StateStyle(
                    textColor: .textNegative,
                    backgroundColor: nil,
                    borderColor: nil
                ),
                .disabled: Button.StateStyle(
                    textColor: .textDisabled,
                    backgroundColor: nil,
                    borderColor: nil
                ),
            ]
        )
    }

    static var link: Button.Style {
        Button.Style(
            borderWidth: 0.0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .textLink,
                    backgroundColor: .clear,
                    borderColor: nil
                ),
                .highlighted: Button.StateStyle(
                    textColor: .textLink,
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
                vertical: Warp.Spacing.spacing50,
                horizontal: 0
            ),
            smallFont: .detail,
            normalFont: .body
        )
    }
}

extension UIControl.State: Hashable {}
