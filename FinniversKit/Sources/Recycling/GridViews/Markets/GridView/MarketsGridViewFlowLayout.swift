//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class MarketsGridViewFlowLayout: UICollectionViewFlowLayout {
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        if let context = context as? UICollectionViewFlowLayoutInvalidationContext, let collectionView = collectionView, !context.invalidateFlowLayoutDelegateMetrics {
            let hasChangedWidth = newBounds.width != collectionView.bounds.width
            context.invalidateFlowLayoutDelegateMetrics = hasChangedWidth
        }
        return context
    }
}
