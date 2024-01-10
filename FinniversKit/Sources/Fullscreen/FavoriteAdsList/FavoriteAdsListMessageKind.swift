import Foundation

public enum FavoriteAdsListMessageKind {
    case message(String, backgroundColor: UIColor)
    case infobox(title: String, message: String, style: InfoboxView.Style)
}
