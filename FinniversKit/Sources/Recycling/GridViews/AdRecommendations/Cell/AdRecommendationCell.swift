//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public protocol AdRecommendationCellDelegate: AnyObject {
    func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton)
}

public protocol AdRecommendationCell: UICollectionViewCell, ImageLoadable {
    var delegate: AdRecommendationCellDelegate? { get set }
    var isFavorite: Bool { get set }
    var index: Int? { get }
}

public protocol AdRecommendationConfigurable: AdRecommendationCell {
    associatedtype Model

    func configure(with model: Model?, atIndex index: Int)
}
