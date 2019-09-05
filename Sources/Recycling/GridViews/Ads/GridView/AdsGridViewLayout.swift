//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol AdsGridViewLayoutDelegate: AnyObject {
    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, itemIsVipAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> Bool
    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, imageHeightRatioForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat
    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, itemNonImageHeightForItemAtIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat
    func adsGridViewLayout(_ adsGridViewLayout: AdsGridViewLayout, heightForHeaderViewInCollectionView collectionView: UICollectionView) -> CGFloat?
}

class AdsGridViewLayout: UICollectionViewLayout {
    private let delegate: AdsGridViewLayoutDelegate
    private var itemAttributes = [UICollectionViewLayoutAttributes]()

    private var configuration: AdsGridViewLayoutConfiguration {
        guard let collectionView = collectionView else {
            fatalError("Layout unusable without collection view!")
        }

        return AdsGridViewLayoutConfiguration(width: collectionView.frame.size.width)
    }

    init(delegate: AdsGridViewLayoutDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func calculateItemWidth() -> CGFloat {
        guard let collectionView = collectionView else {
            return 50.0
        }

        let columnPadding = configuration.columnSpacing * CGFloat(configuration.numberOfColumns - 1)
        let sidePadding = configuration.sidePadding * 2

        let totalPadding = columnPadding + sidePadding
        let columnsWidth = collectionView.frame.size.width - totalPadding

        let columnWidth = columnsWidth / CGFloat(configuration.numberOfColumns)

        return columnWidth
    }

    private var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    private func maxY(forItemAttributes attributes: [UICollectionViewLayoutAttributes]) -> CGFloat {
        var maxY: CGFloat = 0.0

        attributes.forEach { attribute in
            let attributeMaxY = attribute.frame.origin.y + attribute.frame.size.height

            if attributeMaxY > maxY {
                maxY = attributeMaxY
            }
        }

        return maxY
    }

    private func indexOfLowestValue(in columns: [Int]) -> Int {
        let index = columns.firstIndex(of: columns.min() ?? 0) ?? 0
        return index
    }

    private func indexOfHighestValue(in columns: [Int]) -> Int {
        let index = columns.firstIndex(of: columns.max() ?? 0) ?? 0
        return index
    }

    private func xOffsetForItemInColumn(itemWidth: CGFloat, columnIndex: Int) -> CGFloat {
        return (configuration.columnSpacing * CGFloat(columnIndex)) + (itemWidth * CGFloat(columnIndex)) + configuration.sidePadding
    }

    // MARK: - UICollectionViewLayout (Overrides)

    override func prepare() {
        super.prepare()

        itemAttributes = [UICollectionViewLayoutAttributes]()

        guard let collectionView = collectionView else {
            return
        }

        let columnsRange = 0 ..< configuration.numberOfColumns

        var columns = columnsRange.map { _ in 0 }
        var attributesCollection = [UICollectionViewLayoutAttributes]()
        var initialYOffset = configuration.topOffset

        if let height = delegate.adsGridViewLayout(self, heightForHeaderViewInCollectionView: collectionView) {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
            attributes.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: height)
            attributesCollection.append(attributes)

            initialYOffset += height
        }

        var previousItemWasLargeAd = false
        for index in 0 ..< numberOfItems {
            let indexPath = IndexPath(item: index, section: 0)
            let isLargeAd = delegate.adsGridViewLayout(self, itemIsVipAtIndexPath: indexPath, inCollectionView: collectionView)

            let imageHeightRatio = delegate.adsGridViewLayout(self, imageHeightRatioForItemAtIndexPath: indexPath, inCollectionView: collectionView)
            let itemNonImageHeight = delegate.adsGridViewLayout(self, itemNonImageHeightForItemAtIndexPath: indexPath, inCollectionView: collectionView)
            let itemHeight = (imageHeightRatio * calculateItemWidth()) + itemNonImageHeight

            let xOffset: CGFloat
            let itemWidth: CGFloat
            let yOffset: CGFloat

            if isLargeAd {
                let columnIndex = indexOfHighestValue(in: columns)
                xOffset = configuration.sidePadding

                let isFirstItem = index == 0
                let topPadding = isFirstItem ? initialYOffset : 0.0
                yOffset = CGFloat(columns[columnIndex]) + topPadding

                itemWidth = collectionView.frame.size.width - configuration.sidePadding * 2

                for columnIndex in columns.indices {
                    columns[columnIndex] = Int(yOffset + itemHeight + configuration.columnSpacing)
                }
                previousItemWasLargeAd = true
            } else {
                let columnIndex = indexOfLowestValue(in: columns)
                xOffset = xOffsetForItemInColumn(itemWidth: calculateItemWidth(), columnIndex: columnIndex)

                let isFirstRow = configuration.numberOfColumns > index
                let topPadding = isFirstRow && !previousItemWasLargeAd ? initialYOffset : 0.0
                yOffset = CGFloat(columns[columnIndex]) + topPadding

                itemWidth = calculateItemWidth()

                columns[columnIndex] = Int(yOffset + itemHeight + configuration.columnSpacing)
                previousItemWasLargeAd = false
            }

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
            attributesCollection.append(attributes)
        }

        itemAttributes.append(contentsOf: attributesCollection)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { itemAttribute in
            return itemAttribute.frame.intersects(rect)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.row]
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        guard collectionView.numberOfItems(inSection: 0) > 0 else {
            if let height = delegate.adsGridViewLayout(self, heightForHeaderViewInCollectionView: collectionView) {
                return CGSize(width: collectionView.frame.size.width, height: height)
            } else {
                return collectionView.bounds.size
            }
        }

        var size = collectionView.bounds.size
        size.height = maxY(forItemAttributes: itemAttributes)

        return size
    }
}
