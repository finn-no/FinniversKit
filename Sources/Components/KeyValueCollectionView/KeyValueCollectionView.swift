import UIKit

public class KeyValueCollectionView: UIView {
    // MARK: - Public properties

    public var numberOfColumns: Int = 1 {
        didSet {
            guard oldValue != numberOfColumns else { return }

            let layout = layoutFactory.createColumnLayout(numberOfColumns: numberOfColumns)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }

    // MARK: - Private properties

    private lazy var collectionView: UICollectionView = {
        let layout = layoutFactory.createColumnLayout(numberOfColumns: numberOfColumns)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(KeyValueCollectionViewCell.self)
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private let dataSource = KeyValueCollectionDataSource()

    private let layoutFactory = KeyValueCollectionLayoutFactory()

    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func configure(with data: [KeyValuePair]) {
        dataSource.keyValuePairs = data
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let layout = collectionView.collectionViewLayout

        heightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightConstraint?.isActive = true

        if collectionView.bounds.size != layout.collectionViewContentSize {
            layout.invalidateLayout()
        }
    }

    // MARK: - Private methods

    private func setup() {
        dataSource.configure(for: collectionView)
        addSubview(collectionView)
        collectionView.fillInSuperview()
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
    }
}

// MARK: - ColumnBasedFlowLayoutDelegate
extension KeyValueCollectionView: ColumnBasedFlowLayoutDelegate {
    func contentSizeChanged(_ layout: ColumnBasedFlowLayout) {
        heightConstraint?.constant = layout.collectionViewContentSize.height
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }

        let horizontalSpaceBetweenCells = layout.minimumInteritemSpacing * CGFloat(numberOfColumns - 1)

        let contentInset = collectionView.contentInset
        let sectionInset = layout.sectionInset

        let horizontalInsets = contentInset.left - contentInset.right - sectionInset.left - sectionInset.right
        let cellWidth = CGFloat(floor((collectionView.bounds.width - horizontalInsets - horizontalSpaceBetweenCells) / CGFloat(numberOfColumns)))

        let model = dataSource.item(for: indexPath)
        let cellHeight = KeyValueCollectionViewCell.height(for: cellWidth, with: model)

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
