import Foundation

public protocol PreviewPresentable {
    var imageUrl: URL? { get }
    var imageSize: CGSize { get }
    var iconImage: UIImage { get }
    var title: String { get }
    var subTitle: String { get }
    var imageText: String { get }
    var accessibilityLabel: String { get }
}

public extension PreviewPresentable {
    var accessibilityLabel: String {
        return title + ". " + subTitle + ". " + imageText
    }
}
