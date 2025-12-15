import UIKit

public protocol AdRecommendationCellDelegate: AnyObject {
    func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton)
}

public protocol AdRecommendationCell: UICollectionViewCell, ImageLoadable {
    var delegate: AdRecommendationCellDelegate? { get set }
    var isFavorite: Bool { get set }
    var indexPath: IndexPath? { get }
}

public protocol AdRecommendationConfigurable: AdRecommendationCell {
    associatedtype Model

    func configure(with model: Model?, at indexPath: IndexPath)
}
