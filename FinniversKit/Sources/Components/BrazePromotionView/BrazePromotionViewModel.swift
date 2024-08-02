import Foundation

public struct BrazePromotionViewModel {
    let backgroundColor: BrazePromotionView.BackgroundColor
    let borderlessButtonTitle: String?
    let buttonOrientation: BrazePromotionView.ButtonOrientation
    let cardStyle: BrazePromotionView.CardStyle
    let contentAlignment: BrazePromotionView.ContentAlignment
    let dismissible: Bool?
    let image: String?
    let presentation: String?
    let primaryButtonTitle: String?
    let text: String?
    let title: String

    public init(
        backgroundColor: BrazePromotionView.BackgroundColor = .elevatedSurfaceColor,
        borderlessButtonTitle: String? = nil,
        buttonOrientation: BrazePromotionView.ButtonOrientation = .vertical,
        cardStyle: BrazePromotionView.CardStyle = .defaultStyle,
        contentAlignment: BrazePromotionView.ContentAlignment = .left,
        dismissible: Bool? = true,
        image: String? = nil,
        presentation: String?,
        primaryButtonTitle: String? = nil,
        text: String? = nil,
        title: String
    ) {
        self.backgroundColor = backgroundColor
        self.borderlessButtonTitle = borderlessButtonTitle
        self.buttonOrientation = buttonOrientation
        self.cardStyle = cardStyle
        self.contentAlignment = contentAlignment
        self.dismissible = dismissible
        self.image = image
        self.presentation = presentation
        self.primaryButtonTitle = primaryButtonTitle
        self.text = text
        self.title = title
    }
}
