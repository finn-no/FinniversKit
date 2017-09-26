import Foundation

public protocol GridPresentable {
    var image: UIImage? { get }
    var title: String { get }
    var subTitle: String { get }
    var imageText: String { get }
}
