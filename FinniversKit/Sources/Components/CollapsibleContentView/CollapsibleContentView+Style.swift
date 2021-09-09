import UIKit

extension CollapsibleContentView {
    public struct Style {
        public let backgroundColor: UIColor
        public let cornerRadius: CGFloat
        public let contentInsets: UIEdgeInsets
        public let titleStyle: Label.Style
        public let headerContentSpacing: CGFloat

        public init(
            backgroundColor: UIColor,
            cornerRadius: CGFloat,
            contentInsets: UIEdgeInsets,
            titleStyle: Label.Style,
            headerContentSpacing: CGFloat
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.contentInsets = contentInsets
            self.titleStyle = titleStyle
            self.headerContentSpacing = headerContentSpacing
        }

        // MARK: - Defined styles

        public static let plain = Style(
            backgroundColor: .bgPrimary,
            cornerRadius: .zero,
            contentInsets: .init(vertical: .spacingS, horizontal: 0),
            titleStyle: .title3Strong,
            headerContentSpacing: 0
        )

        public static let card = Style(
            backgroundColor: .bgSecondary,
            cornerRadius: 8,
            contentInsets: .init(all: .spacingS),
            titleStyle: .title3Strong,
            headerContentSpacing: 0
        )

        // MARK: - Public methods

        public func withOverride(
            backgroundColor: UIColor? = nil,
            cornerRadius: CGFloat? = nil,
            contentInsets: UIEdgeInsets? = nil,
            titleStyle: Label.Style? = nil,
            headerContentSpacing: CGFloat? = nil
        ) -> CollapsibleContentView.Style {
            CollapsibleContentView.Style(
                backgroundColor: backgroundColor ?? self.backgroundColor,
                cornerRadius: cornerRadius ?? self.cornerRadius,
                contentInsets: contentInsets ?? self.contentInsets,
                titleStyle: titleStyle ?? self.titleStyle,
                headerContentSpacing: headerContentSpacing ?? self.headerContentSpacing
            )
        }
    }
}
