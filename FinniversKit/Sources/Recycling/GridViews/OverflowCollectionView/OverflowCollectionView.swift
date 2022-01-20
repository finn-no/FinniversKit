import UIKit

public protocol OverflowCollectionViewDelegate: AnyObject {
    func overflowCollectionView<Cell>(_ view: OverflowCollectionView<Cell>, didSelectItemAtIndex index: Int)
}

public class OverflowCollectionView<Cell: OverflowCollectionViewCell>: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public struct CellSpacing {
        public let horizontal: CGFloat
        public let vertical: CGFloat

        public init(horizontal: CGFloat, vertical: CGFloat) {
            self.horizontal = horizontal
            self.vertical = vertical
        }
    }

    // MARK: - Public properties

    public weak var delegate: OverflowCollectionViewDelegate?

    // MARK: - Private properties

    private let cellType: Cell.Type
    private let cellSpacing: CellSpacing
    private var models = [Cell.Model]()
    private lazy var collectionViewHeightConstraint = collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
    private lazy var collectionViewLayout = CollectionViewLayout(cellSpacing: cellSpacing)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .bgPrimary
        collectionView.register(cellType)
        return collectionView
    }()

    // MARK: - Init

    public init(cellType: Cell.Type, cellSpacing: CellSpacing, delegate: OverflowCollectionViewDelegate, withAutoLayout: Bool) {
        self.cellType = cellType
        self.cellSpacing = cellSpacing
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
        collectionViewHeightConstraint.isActive = true
    }

    // MARK: - Public methods

    public func configure(with models: [Cell.Model]) {
        self.models = models
        collectionView.reloadData()
        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint.constant = contentHeight
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellType.self, for: indexPath)
        cell.configure(using: models[indexPath.item])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.overflowCollectionView(self, didSelectItemAtIndex: indexPath.item)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let model = models[indexPath.item]
        return cellType.size(using: model)
    }
}

// MARK: - Private types

private extension OverflowCollectionView {
    class CollectionViewLayout: UICollectionViewFlowLayout {

        // MARK: - Private properties

        private let cellSpacing: CellSpacing

        // MARK: - Init

        init(cellSpacing: CellSpacing) {
            self.cellSpacing = cellSpacing
            super.init()
            scrollDirection = .vertical
            minimumInteritemSpacing = cellSpacing.horizontal
            minimumLineSpacing = cellSpacing.vertical
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Overrides

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let attributes = super.layoutAttributesForElements(in: rect) else {
                return nil
            }

            attributes.enumerated().forEach { index, attribute in
                // Skip the first attribute, that one's already correctly placed.
                guard index > 0 else { return }

                let origin = attributes[index - 1].frame.maxX

                // Make sure the new cell is not exceeding the width of the collectionView.
                if origin + cellSpacing.horizontal + attribute.frame.size.width < collectionViewContentSize.width {
                    var newFrame = attribute.frame
                    newFrame.origin.x = origin + cellSpacing.horizontal
                    attribute.frame = newFrame
                }
            }

            return attributes
        }
    }
}
