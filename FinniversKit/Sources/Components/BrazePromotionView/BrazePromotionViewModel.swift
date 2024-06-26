import Foundation

public struct BrazePromotionViewModel {
    let title: String
    let text: String?
    let image: String?
    let primaryButtonTitle: String?
    let borderlessButtonTitle: String?
    let dismissible: Bool?
    let style: BrazePromotionView.CardStyle
    let buttonOrientation: BrazePromotionView.ButtonOrientation

    public init(
        title: String,
        text: String? = nil,
        image: String? = nil,
        primaryButtonTitle: String? = nil,
        borderlessButtonTitle: String? = nil,
        dismissible: Bool? = true,
        style: BrazePromotionView.CardStyle = .defaultStyle,
        buttonOrientation: BrazePromotionView.ButtonOrientation = .vertical
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.primaryButtonTitle = primaryButtonTitle
        self.borderlessButtonTitle = borderlessButtonTitle
        self.dismissible = dismissible
        self.style = style
        self.buttonOrientation = buttonOrientation
    }
}
