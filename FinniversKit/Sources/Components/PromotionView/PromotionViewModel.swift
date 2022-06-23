import Foundation

public struct PromotionViewModel {
    let title: String
    let text: String?
    let image: UIImage
    let imageAlignment: ImageAlignment
    let imageBackgroundColor: UIColor?
    let backgroundImage: UIImage?
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?

    /// Image's alignment inside the image container. The full image will always be visible.
    public enum ImageAlignment {
        case trailing
        case fullWidth
        case dynamic
    }

    public init(
        title: String,
        text: String? = nil,
        image: UIImage,
        imageAlignment: ImageAlignment,
        imageBackgroundColor: UIColor? = nil,
        backgroundImage: UIImage? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.imageAlignment = imageAlignment
        self.imageBackgroundColor = imageBackgroundColor
        self.backgroundImage = backgroundImage
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}
