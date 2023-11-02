//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class MarketsGridViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Always update layout on bounds change
        return collectionView != nil
    }
}
