import Foundation

public struct FrontPageTransactionViewModel {
    let headerTitle: String
    let title: String
    let subtitle: String
    let imageUrl: String?
    let adId: Int?
    let transactionId: String?

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
