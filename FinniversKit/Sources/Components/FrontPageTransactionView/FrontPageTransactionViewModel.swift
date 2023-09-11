import Combine
import Foundation
import SwiftUI
import UIKit

public protocol FrontPageTransactionViewModelDelegate: AnyObject {
    func transactionViewTapped(model: FrontPageTransactionViewModel)
}

public final class FrontPageTransactionViewModel: Swift.Identifiable, ObservableObject {
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
    public var imageLoader: (URL) async throws -> UIImage?
    public weak var delegate: FrontPageTransactionViewModelDelegate?

    @Published
    private(set) var image: UIImage?

    public init(
        id: ID,
        headerTitle: String,
        title: String,
        subtitle: String,
        imageUrl: String? = nil,
        destinationUrl: URL? = nil,
        adId: Int? = nil,
        transactionId: String? = nil,
        imageLoader: @escaping (URL) async -> UIImage? = { _ in nil },
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
        self.imageLoader = imageLoader
        self.delegate = delegate
    }

    func loadImage() async {
        var finalImage = UIImage(named: .noImage)
        if
            let imageUrl,
            let url = URL(string: imageUrl),
            let loadedImage = try? await imageLoader(url)
        {
            finalImage = loadedImage
        }
        withAnimation(.easeOut(duration: 0.2)) {
            image = finalImage
        }
    }

    func transactionTapped() {
        delegate?.transactionViewTapped(model: self)
    }
}
