import Foundation

public struct ObjectPageBlinkViewModel {
    public let title: String
    public let increasedClickPercentage: Int?
    public let increasedClickDescription: String
    public let readMoreButtonTitle: String

    public init(
        title: String,
        increasedClickPercentage: Int?,
        increasedClickDescription: String,
        readMoreButtonTitle: String
    ) {
        self.title = title
        self.increasedClickPercentage = increasedClickPercentage
        self.increasedClickDescription = increasedClickDescription
        self.readMoreButtonTitle = readMoreButtonTitle
    }
}
