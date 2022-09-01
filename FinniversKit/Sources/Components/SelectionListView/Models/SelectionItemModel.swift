import Foundation
import UIKit

public struct SelectionItemModel {
    public let identifier: String?
    public let title: String
    public let description: Description
    public let icon: Icon
    public let detailItems: [String]?
    public let isInitiallySelected: Bool

    public init(
        identifier: String?,
        title: String,
        description: Description,
        icon: Icon,
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
        case html(htmlString: String, style: [String: String] = [:], accessibilityString: String? = nil)
    }

    public enum Icon {
        case fixedSize(UIImage)
        case dynamic(UIImage)

        var image: UIImage {
            switch self {
            case .fixedSize(let image),
                    .dynamic(let image):
                return image
            }
        }
    }
}
