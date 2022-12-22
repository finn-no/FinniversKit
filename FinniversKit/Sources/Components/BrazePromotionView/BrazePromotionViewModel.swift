import Foundation

public struct BrazePromotionViewModel {
    let title: String
    let text: String?
    let image: String?
    let primaryButtonTitle: String?
    let dismissible: Bool?
    public let id: String?

    public init(
        title: String,
        text: String? = nil,
        image: String? = nil,
        primaryButtonTitle: String? = nil,
        dismissible: Bool? = true,
        id: String?
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.primaryButtonTitle = primaryButtonTitle
        self.dismissible = dismissible
        self.id = id
    }
}
