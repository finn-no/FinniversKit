import UIKit
import Warp

extension CollapsibleContentView {
    public struct Style {
        public let backgroundColor: UIColor
        public let cornerRadius: CGFloat
        public let borderWidth: CGFloat
        public let borderColor: UIColor?
        public let contentInsets: UIEdgeInsets
        public let titleStyle: Warp.Typography
        public let headerContentSpacing: CGFloat
        public let hairlineColor: UIColor?

        public init(
            backgroundColor: UIColor,
            cornerRadius: CGFloat,
            borderWidth: CGFloat = 0,
            borderColor: UIColor? = nil,
            contentInsets: UIEdgeInsets,
            titleStyle: Warp.Typography,
            headerContentSpacing: CGFloat,
            hairlineColor: UIColor? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.contentInsets = contentInsets
            self.titleStyle = titleStyle
            self.headerContentSpacing = headerContentSpacing
            self.hairlineColor = hairlineColor
        }

        // MARK: - Defined styles

        public static let plain = Style(
            backgroundColor: .background,
            cornerRadius: .zero,
            contentInsets: .init(vertical: Warp.Spacing.spacing100, horizontal: 0),
            titleStyle: .title3,
            headerContentSpacing: 0
        )

        public static let card = Style(
            backgroundColor: .backgroundInfoSubtle,
            cornerRadius: 8,
            contentInsets: .init(all: Warp.Spacing.spacing100),
            titleStyle: .title3,
            headerContentSpacing: 0
        )

        // MARK: - Public methods

        public func withOverride(
            backgroundColor: UIColor? = nil,
            cornerRadius: CGFloat? = nil,
            borderWidth: CGFloat? = nil,
            borderColor: UIColor? = nil,
            contentInsets: UIEdgeInsets? = nil,
            titleStyle: Warp.Typography? = nil,
            headerContentSpacing: CGFloat? = nil,
            hairlineColor: UIColor? = nil
        ) -> CollapsibleContentView.Style {
            CollapsibleContentView.Style(
                backgroundColor: backgroundColor ?? self.backgroundColor,
                cornerRadius: cornerRadius ?? self.cornerRadius,
                borderWidth: borderWidth ?? self.borderWidth,
                borderColor: borderColor ?? self.borderColor,
                contentInsets: contentInsets ?? self.contentInsets,
                titleStyle: titleStyle ?? self.titleStyle,
                headerContentSpacing: headerContentSpacing ?? self.headerContentSpacing,
                hairlineColor: hairlineColor ?? self.hairlineColor
            )
        }
    }
}
