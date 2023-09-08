import Foundation

public struct FrontPageTransactionViewModel {
    public struct ID: Hashable, RawRepresentable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let headerTitle: String
    public let title: String
    public let subtitle: String
    public let imageUrl: String?
    public let destinationUrl: URL?
    public let adId: Int?
    public let transactionId: String?

    public init(
        id: ID,
        headerTitle: String,
        title: String,
        subtitle: String,
        imageUrl: String? = nil,
        destinationUrl: URL? = nil,
        adId: Int? = nil,
        transactionId: String? = nil
    ) {
        self.id = id
        self.headerTitle = headerTitle
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.destinationUrl = destinationUrl
        self.adId = adId
        self.transactionId = transactionId
    }
}
