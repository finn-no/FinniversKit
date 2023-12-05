import Foundation

public extension BadgeView {
    struct Style: Hashable {
        public let backgroundColor: UIColor
        public let textColor: UIColor

        public init(backgroundColor: UIColor, textColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }

        public static var `default`: Self { .init(backgroundColor: .backgroundInfoSubtle, textColor: .text) }
        public static var warning: Self { .init(backgroundColor: .backgroundWarningSubtle, textColor: .warningTextColor) }
        public static var sponsored: Self { .init(backgroundColor: .accentToothpaste, textColor: .aqua800) }
        public static var motorSmidig: Self { .init(backgroundColor: .green100, textColor: .gray700) }
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var warningTextColor: UIColor {
        UIColor(hex: "#885407")
    }
}
