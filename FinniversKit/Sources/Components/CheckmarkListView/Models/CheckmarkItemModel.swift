import Foundation

public struct CheckmarkItemModel {
    public let title: String
    public let description: Description
    public let icon: UIImage
    public let isInitiallySelected: Bool

    public init(title: String, description: Description, icon: UIImage, isInitiallySelected: Bool) {
        self.title = title
        self.description = description
        self.icon = icon
        self.isInitiallySelected = isInitiallySelected
    }

    public enum Description {
        case plain(String)
        case attributed(NSAttributedString)
    }
}
