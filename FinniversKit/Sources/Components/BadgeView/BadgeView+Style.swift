import Foundation
import Warp

public extension BadgeView {
    struct Style: Hashable {
        public let backgroundColor: UIColor
        public let textColor: UIColor

        public init(backgroundColor: UIColor, textColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }

        public static var `default`: Self { .init(backgroundColor: Warp.UIColor.badgeInfoBackground, textColor: .text) }
        public static var warning: Self { .init(backgroundColor: Warp.UIColor.badgeWarningBackground, textColor: .text) }
        public static var sponsored: Self { .init(backgroundColor: Warp.UIColor.badgeSponsoredBackground, textColor: .text) }
        public static var motorSmidig: Self { .init(backgroundColor: Warp.UIColor.badgePositiveBackground, textColor: .text) }
    }
}
