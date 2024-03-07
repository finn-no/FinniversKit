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
        public static var warning: Self { .init(backgroundColor: .backgroundWarningSubtle, textColor: .text) }
        public static var sponsored: Self { .init(backgroundColor: warpUIColor.badgeSponsoredBackground, textColor: .text) } // change this to backgroundSponsored
        public static var motorSmidig: Self { .init(backgroundColor: warpUIColor.badgePositiveBackground, textColor: .text) } // use badgePositive
    }
}
