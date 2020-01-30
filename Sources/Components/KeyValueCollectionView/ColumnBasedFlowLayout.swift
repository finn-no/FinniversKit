import UIKit

protocol ColumnBasedFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func contentSizeChanged(_ layout: ColumnBasedFlowLayout)
}

public class ColumnBasedFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Public properties

    public let numberOfColumns: Int

    // MARK: - Private properties

    private var cachedCollectionViewBounds: CGRect = .zero

    // MARK: - Initializers

    public init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
        super.init()
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = .mediumLargeSpacing
        minimumInteritemSpacing = .mediumLargeSpacing
    }

    // MARK: - Overrides

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard newBounds != cachedCollectionViewBounds else { return false }

        cachedCollectionViewBounds = newBounds
        return true
    }

    public override func prepare() {
        super.prepare()
        (collectionView?.delegate as? ColumnBasedFlowLayoutDelegate)?.contentSizeChanged(self)
    }
}
