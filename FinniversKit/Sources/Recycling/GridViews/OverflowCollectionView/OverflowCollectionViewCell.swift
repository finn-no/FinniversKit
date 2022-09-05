import UIKit

public protocol OverflowCollectionViewCell: UICollectionViewCell {
    associatedtype Model
    static func size(using model: Model) -> CGSize
    func configure(using model: Model)
}
