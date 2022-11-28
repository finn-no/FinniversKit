import UIKit

public protocol ScrollableTabViewDelegate: AnyObject {
    func scrollableTabViewDidTapItem(_ sidescrollableView: ScrollableTabView, item: ScrollableTabViewModel.Item)
}

public class ScrollableTabView: BottomShadowView {

    // MARK: - Public properties

    public weak var delegate: ScrollableTabViewDelegate?

    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: ItemCollectionViewCell.cellHeight
        )
    }

    // MARK: - Private properties

    private var itemModels = [ScrollableTabViewModel.Item]()
    private lazy var dataSource = createDataSource()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .bgPrimary
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = false
        collectionView.register(ItemCollectionViewCell.self)
        return collectionView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ScrollableTabViewModel) {
        itemModels = viewModel.items
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)

        dataSource.apply(snapshot)
        let selectedIndex = viewModel.items.firstIndex(where: { $0.identifier == viewModel.selectedIdentifier })
        collectionView.selectItem(at: indexPath(for: selectedIndex), animated: false, scrollPosition: .centeredHorizontally)
    }

    // MARK: - Private methods

    private func indexPath(for itemIndex: Int?) -> IndexPath? {
        guard let itemIndex = itemIndex else { return nil }
        return IndexPath(item: itemIndex, section: Section.main.rawValue)
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            invalidateIntrinsicContentSize()
        }
    }
}

// MARK: - CollectionView Datasource and layout

private extension ScrollableTabView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ScrollableTabViewModel.Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ScrollableTabViewModel.Item>

    private enum Section: Int, Hashable {
        case main
    }

    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { section, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(50),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(50),
                heightDimension: .estimated(ItemCollectionViewCell.cellHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 32
            section.contentInsets = .init(vertical: 0, horizontal: .spacingM)
            return section
        }
    }

    private func createDataSource() -> DataSource {
        DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeue(ItemCollectionViewCell.self, for: indexPath)
                cell.configure(item: item)
                return cell
            }
        )
    }
}

// MARK: - UICollectionViewDelegate

extension ScrollableTabView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if !(collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false), let itemModel = itemModels[safe: indexPath.item] {
            delegate?.scrollableTabViewDidTapItem(self, item: itemModel)
        }

        return true
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
