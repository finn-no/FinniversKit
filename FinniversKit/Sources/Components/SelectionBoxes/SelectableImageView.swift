import Foundation

public protocol SelectableImageView: UIImageView {
    var isSelected: Bool { get }
    func configure(isSelected: Bool)
}
