import Foundation

public struct SelectionItemModel {
    public let identifier: String?
    public let title: String
    public let description: Description
    public let icon: UIImage
    public let detailItems: [String]?
    public let isInitiallySelected: Bool

    public init(
        identifier: String?,
        title: String,
        description: Description,
        icon: UIImage,
        detailItems: [String]? = nil,
        isInitiallySelected: Bool
    ) {
        self.identifier = identifier
        self.title = title
        self.description = description
        self.icon = icon
        self.detailItems = detailItems
        self.isInitiallySelected = isInitiallySelected
    }

    public enum Description {
        case plain(String)
        case attributed(NSAttributedString)
    }
}
