import UIKit

public struct MyAdModel: Hashable {
    public let adId: String
    public let title: String
    public let subtitle: String?
    public let imageUrl: String?
    public let expires: String?
    public let numFavorites: String
    public let numViews: String
    public let ribbon: RibbonViewModel

    public init(
        adId: String,
        title: String,
        subtitle: String?,
        imageUrl: String?,
        expires: String?,
        numFavorites: String,
        numViews: String,
        ribbon: RibbonViewModel
    ) {
        self.adId = adId
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.expires = expires
        self.numFavorites = numFavorites
        self.numViews = numViews
        self.ribbon = ribbon
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(adId)
    }
}
