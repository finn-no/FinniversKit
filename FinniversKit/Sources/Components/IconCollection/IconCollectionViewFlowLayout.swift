//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class IconCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        if let context = context as? UICollectionViewFlowLayoutInvalidationContext, let collectionView = collectionView, !context.invalidateFlowLayoutDelegateMetrics {
            let hasChangedWidth = newBounds.width != collectionView.bounds.width
            context.invalidateFlowLayoutDelegateMetrics = hasChangedWidth
        }
        return context
    }

    /// Top-align collection view cells
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)?.map {
            $0.copy()
        } as? [UICollectionViewLayoutAttributes]

        let cellAttributes = layoutAttributes?.filter { $0.representedElementCategory == .cell } ?? []
        var rowAttributes = [CGFloat: [UICollectionViewLayoutAttributes]]()

        for cellAttribute in cellAttributes {
            let centerY = ceil(cellAttribute.center.y)

            if rowAttributes[centerY] == nil {
                rowAttributes[centerY] = [cellAttribute]
            } else {
                rowAttributes[centerY]?.append(cellAttribute)
            }
        }

        for attributes in rowAttributes.values {
            let maxHeightY = attributes.max { $0.frame.size.height < $1.frame.size.height }?.frame.origin.y

            for attribute in attributes {
                let dy = (maxHeightY ?? attribute.frame.origin.y) - attribute.frame.origin.y
                attribute.frame = attribute.frame.offsetBy(dx: 0, dy: dy)
            }
        }

        return layoutAttributes
    }
}
