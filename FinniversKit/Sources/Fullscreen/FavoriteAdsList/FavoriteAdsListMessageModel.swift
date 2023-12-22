import Foundation

public struct FavoriteAdsListMessageModel {
    public let message: String
    public let panelStyle: Panel.Style

    public init(message: String, panelStyle: Panel.Style) {
        self.message = message
        self.panelStyle = panelStyle
    }
}
