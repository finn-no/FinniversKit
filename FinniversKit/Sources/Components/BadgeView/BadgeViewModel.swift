import Foundation
import UIKit

public struct BadgeViewModel {
    public let style: BadgeView.Style
    public let title: String
    public let icon: UIImage?

    public init(style: BadgeView.Style, title: String, icon: UIImage? = nil) {
        self.style = style
        self.title = title
        self.icon = icon
    }
}
