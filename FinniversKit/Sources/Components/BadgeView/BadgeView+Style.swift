import Foundation

public extension BadgeView {
    struct Style: Hashable {
        public let backgroundColor: UIColor
        public let textColor: UIColor

        public init(backgroundColor: UIColor, textColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }

        public static var `default`: Self { .init(backgroundColor: .bgSecondary, textColor: .textPrimary) }
        public static var warning: Self { .init(backgroundColor: .bgAlert, textColor: .textAlert) }
        public static var sponsored: Self { .init(backgroundColor: .accentToothpaste, textColor: .aqua800) }
        public static var motorSmidig: Self { .init(backgroundColor: .green100, textColor: .gray700) }
    }
}
