import Foundation

public struct ObjectPageBlinkViewModel {
    public let icon: UIImage
    public let title: String
    public let increasedClickPercentage: Int?
    public let increasedClickDescription: String
    public let readMoreButtonTitle: String

    public init(
        icon: UIImage,
        title: String,
        increasedClickPercentage: Int?,
        increasedClickDescription: String,
        readMoreButtonTitle: String
    ) {
        self.icon = icon
        self.title = title
        self.increasedClickPercentage = increasedClickPercentage
        self.increasedClickDescription = increasedClickDescription
        self.readMoreButtonTitle = readMoreButtonTitle
    }
}
