import UIKit

public class CompactMarketsView: UIView, MarketsView {

    // MARK: - Private properties

    private weak var delegate: MarketsViewDelegate?
    private weak var dataSource: MarketsViewDataSource?

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .spacingS
        layout.minimumInteritemSpacing = .spacingS
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(CompactMarketsViewCell.self)
        collectionView.contentInset = UIEdgeInsets(vertical: 0, horizontal: .spacingM)
        return collectionView
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    // MARK: - Init

    public init(
        frame: CGRect = .zero,
        delegate: MarketsViewDelegate,
        dataSource: MarketsViewDataSource
    ) {
        super.init(frame: frame)

        self.delegate = delegate
        self.dataSource = dataSource

        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(collectionView)
        addSubview(hairlineView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            hairlineView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    // MARK: - Public methods

    public func reloadData() {
        collectionView.reloadData()
    }

    public func calculateSize(constrainedTo width: CGFloat) -> CGSize {
        CGSize(width: width, height: 76)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompactMarketsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let model = dataSource?.marketsView(self, modelAtIndex: indexPath.item) else {
            return .zero
        }

        return CompactMarketsViewCell.size(for: model)
    }
}

// MARK: - UICollectionViewDataSource

extension CompactMarketsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.numberOfItems(inMarketsView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CompactMarketsViewCell.self, for: indexPath)

        if let model = dataSource?.marketsView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CompactMarketsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.marketsView(self, didSelectItemAtIndex: indexPath.row)
    }
}
