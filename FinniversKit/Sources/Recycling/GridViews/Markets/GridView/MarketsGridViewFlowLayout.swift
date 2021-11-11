//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class MarketsGridViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        return collectionView.bounds.width != newBounds.width
    }
}
