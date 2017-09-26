import Foundation

public protocol PreviewPresentable {
    var image: UIImage? { get }
    var title: String { get }
    var subTitle: String { get }
    var imageText: String { get }
}
