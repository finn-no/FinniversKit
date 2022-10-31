import UIKit
import Combine

public protocol MyAdsListViewDelegate: AnyObject {
    func myAdsListView(_ view: MyAdsListView, didSelectAdAt indexPath: IndexPath)
    func myAdsListViewDidScrollToBottom(_ view: MyAdsListView)
    func myAdsListViewDidStartRefreshing(_ view: MyAdsListView)

    /// Optional methods.
    func myAdsListView(_ view: MyAdsListView, scrollViewDidChangeContentOffset scrollView: UIScrollView)
    func myAdsListView(_ view: MyAdsListView, scrollViewWillBeginDragging scrollView: UIScrollView)
    func myAdsListView(_ view: MyAdsListView, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate: Bool)
    func myAdsListView(_ view: MyAdsListView, scrollViewDidEndDecelerating scrollView: UIScrollView)
}

public extension MyAdsListViewDelegate {
    func myAdsListView(_ view: MyAdsListView, scrollViewDidChangeContentOffset scrollView: UIScrollView) {}
    func myAdsListView(_ view: MyAdsListView, scrollViewWillBeginDragging scrollView: UIScrollView) {}
    func myAdsListView(_ view: MyAdsListView, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate: Bool) {}
    func myAdsListView(_ view: MyAdsListView, scrollViewDidEndDecelerating scrollView: UIScrollView) {}
}

public class MyAdsListView: UIView {

    // MARK: - Public properties

    public weak var delegate: MyAdsListViewDelegate?

    public var contentInsetBottom: CGFloat {
        get { collectionView.contentInset.bottom }
        set { collectionView.contentInset.bottom = newValue }
    }

    // MARK: - Private properties

    private var dataSourceHasMoreContent = false
    private var isWaitingForMoreContent = false
    private var contentOffsetCancellable: AnyCancellable?
    private lazy var dataSource = createDataSource()
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.register(MyAdCollectionViewCell.self)
        collectionView.register(LoadingIndicatorCollectionViewCell.self)
        collectionView.refreshControl = refreshControl
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    private lazy var refreshControl: RefreshControl = {
        let refreshControl = RefreshControl(frame: .zero)
        refreshControl.delegate = self
        return refreshControl
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

        contentOffsetCancellable = collectionView
            .publisher(for: \.contentOffset, options: .new)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.myAdsListView(self, scrollViewDidChangeContentOffset: self.collectionView)
            })
    }

    // MARK: - Public methods

    public func configure(with adModels: [MyAdModel], hasMoreContent: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.ads])
        let items = adModels.map { Item.ad($0) }
        snapshot.appendItems(items, toSection: .ads)

        if hasMoreContent {
            snapshot.appendSections([.spinner])
            snapshot.appendItems([.spinner(UUID())], toSection: .spinner)
        }

        dataSourceHasMoreContent = hasMoreContent
        isWaitingForMoreContent = false
        dataSource.apply(snapshot, completion: { [weak self] in
            self?.refreshControl.endRefreshing()
        })
    }
}

// MARK: - Private types

private extension MyAdsListView {
    enum Section: Int, Hashable {
        case ads
        case spinner
    }

    enum Item: Hashable {
        case ad(MyAdModel)
        case spinner(UUID)
    }
}

// MARK: - CollectionView Datasource and layout

private extension MyAdsListView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { section, _ in
            guard let section = Section(rawValue: section) else { return nil }

            switch section {
            case .ads:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(112) // Sum of image height + padding top/bottom.
                )

                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                return NSCollectionLayoutSection(group: group)
            case .spinner:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40) // Sum of spinner height + padding top/bottom.
                )

                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                return NSCollectionLayoutSection(group: group)
            }
        }
    }

    private func createDataSource() -> DataSource {
        DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                switch item {
                case .ad(let adModel):
                    let cell = collectionView.dequeue(MyAdCollectionViewCell.self, for: indexPath)
                    cell.configure(ad: adModel, remoteImageViewDataSource: self?.remoteImageViewDataSource)
                    return cell
                case .spinner:
                    return collectionView.dequeue(LoadingIndicatorCollectionViewCell.self, for: indexPath)
                }
        })
    }
}

// MARK: - UICollectionViewDelegate

extension MyAdsListView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.myAdsListView(self, didSelectAdAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellCount = collectionView.numberOfItems(inSection: 0)
        if dataSourceHasMoreContent, !isWaitingForMoreContent && indexPath.item >= cellCount - 5 {
            isWaitingForMoreContent = true
            delegate?.myAdsListViewDidScrollToBottom(self)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.myAdsListView(self, scrollViewWillBeginDragging: scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.myAdsListView(self, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.myAdsListView(self, scrollViewDidEndDecelerating: scrollView)
    }
}

// MARK: - RefreshControlDelegate
extension MyAdsListView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.myAdsListViewDidStartRefreshing(self)
    }
}
