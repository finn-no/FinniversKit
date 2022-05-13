import Foundation

public struct FrontPageTransactionViewModel {
    public let headerTitle: String
    public let title: String
    public let subtitle: String
    public let imageUrl: String?
    public let adId: Int?
    public let transactionId: String?

    public init(headerTitle: String,
                title: String,
                subtitle: String,
                imageUrl: String? = nil,
                adId: Int? = nil,
                transactionId: String? = nil
                ) {
        self.headerTitle = headerTitle
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.adId = adId
        self.transactionId = transactionId
    }
}
