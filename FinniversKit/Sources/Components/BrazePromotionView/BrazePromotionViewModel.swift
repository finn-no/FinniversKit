import Foundation

public struct BrazePromotionViewModel {
    let title: String
    let text: String?
    let image: String?
    let primaryButtonTitle: String?


    public init(
        title: String,
        text: String? = nil,
        image: String? = nil,
        primaryButtonTitle: String? = nil
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.primaryButtonTitle = primaryButtonTitle
    }
}
