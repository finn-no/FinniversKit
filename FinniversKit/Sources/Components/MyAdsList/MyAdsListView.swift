import UIKit

public protocol MyAdsListViewDelegate: AnyObject {
    func myAdsListView(_ view: MyAdsListView, didSelectAdAt indexPath: IndexPath)
}

public class MyAdsListView: UIView {

    // MARK: - Public properties

    public weak var delegate: MyAdsListViewDelegate?

    // MARK: - Private properties

    private lazy var dataSource = createDataSource()
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.register(MyAdCollectionViewCell.self)
        return collectionView
    }()

    // MARK: - Init

    public init(remoteImageViewDataSource: RemoteImageViewDataSource, withAutoLayout: Bool) {
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with adModels: [MyAdModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(adModels)
        dataSource.apply(snapshot)
    }
}

// MARK: - CollectionView Datasource and layout

private extension MyAdsListView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, MyAdModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MyAdModel>

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(112) // Sum of image height + padding top/bottom for MyAdCollectionViewCell.
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func createDataSource() -> DataSource {
        DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                let cell = collectionView.dequeue(MyAdCollectionViewCell.self, for: indexPath)
                cell.configure(ad: item, remoteImageViewDataSource: self?.remoteImageViewDataSource)
                return cell
        })
    }
}

// MARK: - UICollectionViewDelegate

extension MyAdsListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.myAdsListView(self, didSelectAdAt: indexPath)
    }
}
