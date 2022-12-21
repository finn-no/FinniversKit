import Foundation
import UIKit

public struct BadgeViewModel {
    public let title: String
    public let icon: UIImage?

    public init(title: String, icon: UIImage? = nil) {
        self.title = title
        self.icon = icon
    }
}
