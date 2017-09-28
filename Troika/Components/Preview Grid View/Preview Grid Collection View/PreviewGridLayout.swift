import UIKit

protocol PreviewGridLayoutDelegate {
    func imageHeightRatio(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat
    func itemNonImageHeight(forItemAt indexPath: IndexPath, inCollectionView collectionView: UICollectionView) -> CGFloat
}

class PreviewGridLayout: UICollectionViewLayout {

    private let delegate: PreviewGridLayoutDelegate
    private var itemAttributes = [UICollectionViewLayoutAttributes]()

    private var configuration: PreviewGridLayoutConfigurable {
        guard let window = collectionView?.window else {
            fatalError("Layout unusable without window!")
        }

        let iPhone7ScreenWidth: CGFloat = 375.0

        switch window.frame.size.width {
        case let width where width > iPhone7ScreenWidth: return PreviewGridLayoutIPad()
        case let width where width < iPhone7ScreenWidth: return PreviewGridLayoutIPhoneSmall()
        default: return PreviewGridLayoutIPhone()
        }
    }

    init(delegate: PreviewGridLayoutDelegate) {
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

    // MARK: - UICollectionViewLayout (Overrides)

    override func prepare() {
        super.prepare()

        itemAttributes = [UICollectionViewLayoutAttributes]()

        guard let collectionView = collectionView else {
            return
        }

        let columnsRange = 0..<configuration.numberOfColumns

        var columns = columnsRange.map { _ in 0 }
        var attributesCollection = [UICollectionViewLayoutAttributes]()

        for index in 0..<numberOfItems {

            let columnIndex = indexOfLowestValue(in: columns)

            let xOffset = xOffsetForItemInColumn(itemWidth: itemWidth, columnIndex: columnIndex)
            let topPadding = configuration.numberOfColumns > index ? configuration.topOffset : 0.0
            let verticalOffset = CGFloat(columns[columnIndex]) + topPadding

            let indexPath = IndexPath(item: index, section: 0)
            let imageHeightRatio = delegate.imageHeightRatio(forItemAt: indexPath, inCollectionView: collectionView)
            let itemNonImageHeight = delegate.itemNonImageHeight(forItemAt: indexPath, inCollectionView: collectionView)

            let itemHeight = (imageHeightRatio * itemWidth) + itemNonImageHeight

            columns[columnIndex] = Int(verticalOffset + itemHeight + configuration.columnSpacing)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: xOffset, y: verticalOffset, width: itemWidth, height: itemHeight)
            attributesCollection.append(attributes)
        }

        itemAttributes.append(contentsOf: attributesCollection)
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

