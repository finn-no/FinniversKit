import Foundation

public struct BrazePromotionViewModel {
    let title: String
    let text: String?
    let image: String?
    let primaryButtonTitle: String?
    let dismissible: Bool?
    let cardStyle: String?

    public init(
        title: String,
        text: String? = nil,
        image: String? = nil,
        primaryButtonTitle: String? = nil,
        dismissible: Bool? = true,
        cardStyle: String? = "default"
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.primaryButtonTitle = primaryButtonTitle
        self.dismissible = dismissible
        self.cardStyle = cardStyle
    }
}
