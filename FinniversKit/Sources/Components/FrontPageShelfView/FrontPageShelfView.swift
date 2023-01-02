import UIKit

public protocol FrontPageShelfDelegate: AnyObject {
    func frontPageShelfView(_ view: FrontPageSavedSearchView, didSelectSavedSearchItem item: SavedSearchShelfViewModel)
    func frontPageShelfView(_ view: FrontPageSavedSearchView, didSelectHeaderForSection section: FrontPageSavedSearchView.Section)
}

public class FrontPageSavedSearchView: UIView {
    static let topPadding: CGFloat = .spacingL
    static let headerHeight: CGFloat = 44
    static let savedSearchCellHeight: CGFloat = 100

    typealias Datasource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

    public enum Section: Int, CaseIterable {
        case savedSearch
    }

    private var collectionViewDatasource: Datasource!
    private var items: [Section: [AnyHashable]] = [:]
    public weak var shelfDelegate: FrontPageShelfDelegate?
    private weak var remoteImageDataSource: RemoteImageViewDataSource?
    private var scrollToSavedSearchIndexPath: IndexPath?
    private let title: String
    private let buttonTitle: String

    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.savedSearchLayout
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(SavedSearchShelfCell.self)
        collectionView.register(FrontPageShelfHeaderView.self, ofKind: FrontPageShelfHeaderView.reuseIdentifier)
        return collectionView
    }()

    public init(
        title: String,
        buttonTitle: String,
        remoteImageDataSource: RemoteImageViewDataSource?
    ) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.remoteImageDataSource = remoteImageDataSource
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let indexPath = scrollToSavedSearchIndexPath {
            self.scrollToSavedSearchIndexPath = nil
            // Using centeredHorizontally for the first cell to preserve leading content inset for iOS 14 and below.
            let scrollPosition: UICollectionView.ScrollPosition = indexPath.item == 0 ? .centeredHorizontally : .left
            collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
}

// MARK: - Public method
public extension FrontPageSavedSearchView {
    func configure(with savedSearches: [SavedSearchShelfViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.savedSearch])
        snapshot.appendItems(savedSearches, toSection: .savedSearch)
        collectionViewDatasource.apply(snapshot, animatingDifferences: true)
    }

    func scrollToSavedSearch(atIndex index: Int) {
        scrollToSavedSearchIndexPath = IndexPath(item: index, section: Section.savedSearch.rawValue)
        setNeedsLayout()
    }
}

// MARK: - Setup
private extension FrontPageSavedSearchView {
    func setup() {
        addSubview(collectionView)

        collectionView.backgroundColor = .bgQuaternary
        collectionView.fillInSuperview()
        collectionViewDatasource = makeDatasource()
    }
}

// MARK: - Layout
private extension FrontPageSavedSearchView {
    private var savedSearchLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Self.savedSearchCellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(SavedSearchShelfCell.width), heightDimension: .absolute(Self.savedSearchCellHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        //Sections
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .spacingS + .spacingXS

        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Self.headerHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageShelfHeaderView.reuseIdentifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]

        return section
    }
}

// MARK: - Datasource
private extension FrontPageSavedSearchView {
    private func makeDatasource() -> Datasource {
        let datasource = Datasource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let viewModel = item as? SavedSearchShelfViewModel else { return UICollectionViewCell() }

            let cell = collectionView.dequeue(SavedSearchShelfCell.self, for: indexPath)
            cell.configure(withModel: viewModel)
            cell.imageDatasource = self?.remoteImageDataSource
            cell.loadImage()
            return cell
        }

        datasource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }

            let headerView = collectionView.dequeue(FrontPageShelfHeaderView.self, for: indexPath, ofKind: kind)
            headerView.configureHeaderView(
                withTitle: self.title,
                buttonTitle: self.buttonTitle,
                buttonAction: {
                self.shelfDelegate?.frontPageShelfView(self, didSelectHeaderForSection: .savedSearch)
            })
            return headerView
        }

        return datasource
    }
}

// MARK: - UICollectionViewDelegate
extension FrontPageSavedSearchView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let item = collectionViewDatasource.itemIdentifier(for: indexPath) as? SavedSearchShelfViewModel
        else { return }

        shelfDelegate?.frontPageShelfView(self, didSelectSavedSearchItem: item)
    }
}
