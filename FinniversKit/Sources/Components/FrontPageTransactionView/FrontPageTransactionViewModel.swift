import Foundation

public protocol FrontPageTransactionViewModelDelegate: AnyObject {
    func transactionViewTapped(model: FrontPageTransactionViewModel)
}

public struct FrontPageTransactionViewModel: Swift.Identifiable {
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
    public weak var delegate: FrontPageTransactionViewModelDelegate?

    let imageWidth: CGFloat = 56

    public init(
        id: ID,
        headerTitle: String,
        title: String,
        subtitle: String,
        imageUrl: String? = nil,
        destinationUrl: URL? = nil,
        adId: Int? = nil,
        transactionId: String? = nil,
        delegate: FrontPageTransactionViewModelDelegate? = nil
    ) {
        self.id = id
        self.headerTitle = headerTitle
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.destinationUrl = destinationUrl
        self.adId = adId
        self.transactionId = transactionId
        self.delegate = delegate
    }

    func transactionTapped() {
        delegate?.transactionViewTapped(model: self)
    }
}
