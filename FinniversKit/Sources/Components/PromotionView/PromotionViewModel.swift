import Foundation

public struct PromotionViewModel {
    let title: String
    let text: String?
    let image: UIImage
    let imageAlignment: ImageAlignment
    let imageBackgroundColor: UIColor?
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?

    /// Image's alignment inside the image container. The full image will always be visible.
    public enum ImageAlignment {
        case trailing
        case fullWidth
    }

    public init(
        title: String,
        text: String? = nil,
        image: UIImage,
        imageAlignment: ImageAlignment,
        imageBackgroundColor: UIColor? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.imageAlignment = imageAlignment
        self.imageBackgroundColor = imageBackgroundColor
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}
