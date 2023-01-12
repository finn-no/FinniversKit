import UIKit

public struct MyAdModel: Hashable {
    public let adId: String
    public let title: String
    public let subtitle: String?
    public let imageUrl: String?
    public let expires: LabelItem?
    public let statisticFavorites: LabelItem
    public let statisticViews: LabelItem
    public let ribbon: RibbonViewModel

    public init(
        adId: String,
        title: String,
        subtitle: String?,
        imageUrl: String?,
        expires: LabelItem?,
        statisticFavorites: LabelItem,
        statisticViews: LabelItem,
        ribbon: RibbonViewModel
    ) {
        self.adId = adId
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.expires = expires
        self.statisticFavorites = statisticFavorites
        self.statisticViews = statisticViews
        self.ribbon = ribbon
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(adId)
    }
}

extension MyAdModel {
    public struct LabelItem: Hashable {
        public let title: String
        public let accessibilityTitle: String

        public init(title: String, accessibilityTitle: String) {
            self.title = title
            self.accessibilityTitle = accessibilityTitle
        }
    }
}
