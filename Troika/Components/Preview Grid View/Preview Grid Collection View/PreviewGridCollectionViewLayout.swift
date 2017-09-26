import UIKit

protocol PreviewGridCollectionViewLayoutDelegate {
    func relativeHeightForItem(atIndexPath indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat
}

class PreviewGridCollectionViewLayout: UICollectionViewLayout {

    private let delegate: PreviewGridCollectionViewLayoutDelegate
    private var itemAttributes = [UICollectionViewLayoutAttributes]()

    private var configuration: PreviewGridCollectionViewLayoutConfigurable {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return PreviewGridCollectionViewLayoutIPad()
        }

        if let window = collectionView?.window, window.frame.size.width < CGFloat(375.0) {
            return PreviewGridCollectionViewLayoutIPhoneSmall()
        }

        return PreviewGridCollectionViewLayoutIPhone()
    }

    init(delegate: PreviewGridCollectionViewLayoutDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var itemWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 50.0
        }

        let columnPadding = configuration.columnSpacing * CGFloat(configuration.numberOfColumns - 1)
        let sidePadding   = configuration.sidePadding * 2

        let totalPadding = columnPadding + sidePadding
        let columnsWidth = collectionView.frame.size.width - totalPadding

        let columnWidth = columnsWidth / CGFloat(configuration.numberOfColumns)

        return columnWidth
    }

    private var itemHeight: CGFloat {
        return itemWidth
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
        return columns.index(of: columns.min() ?? 0) ?? 0 // Shortest column index
    }

    private func xOffsetForItemInColumn(itemWidth: CGFloat, columnIndex: Int) -> CGFloat {
        return (configuration.columnSpacing * CGFloat(columnIndex)) + (itemWidth * CGFloat(columnIndex)) + configuration.sidePadding
    }

    private func prepareDiscoverSection(offset: CGFloat) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = collectionView else {
            return []
        }

        let columnsRange = 0..<configuration.numberOfColumns

        var columns = columnsRange.map { _ in 0 }
        var attributesCollection = [UICollectionViewLayoutAttributes]()

        for index in 0..<numberOfItems {

            let columnIndex = indexOfLowestValue(in: columns)

            let xOffset = xOffsetForItemInColumn(itemWidth: itemWidth, columnIndex: columnIndex)
            let topPadding = configuration.numberOfColumns > index ? offset : 0.0
            let verticalOffset = CGFloat(columns[columnIndex]) + topPadding

            let indexPath = IndexPath(item: index, section: 1)
            let itemRelativeHeight = delegate.relativeHeightForItem(atIndexPath: indexPath, inCollectionView: collectionView)
            let itemAdditionalHeight = configuration.nonImageHeightForItems // No good.

            let itemHeight = (itemRelativeHeight * itemWidth) + itemAdditionalHeight

            columns[columnIndex] = Int(verticalOffset + itemHeight + configuration.columnSpacing)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xOffset, y: verticalOffset, width: itemWidth, height: itemHeight)
            attributesCollection.append(attributes)
        }

        return attributesCollection
    }

    // MARK: - UICollectionViewLayout (Overrides)

    override func prepare() {
        super.prepare()

        itemAttributes = [UICollectionViewLayoutAttributes]()

        let section = prepareDiscoverSection(offset: configuration.topOffset)

        itemAttributes.append(contentsOf: section)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.filter { a in
            return a.frame.intersects(rect)
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
            return collectionView.bounds.size
        }

        var size = collectionView.bounds.size
        size.height = maxY(forItemAttributes: itemAttributes)

        return size
    }
}

