import UIKit

public protocol FrontPageShelfViewDataSource: AnyObject {
    func frontPageShelfView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell?
    func frontPageShelfView(cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func datasource(forSection section: FrontPageShelfView.Section) -> [AnyHashable]
    func frontPageShelfView(_ frontPageShelfView: FrontPageShelfView, titleForSectionAt index: Int) -> String
    func frontPageShelfView(_ frontPageShelfView: FrontPageShelfView, titleForButtonForSectionAt index: Int) -> String
}

public protocol FrontPageShelfDelegate: AnyObject {
    func frontPageShelfView(_ view: FrontPageShelfView, didSelectFavoriteItem item: RecentlyFavoritedViewmodel)
    func frontPageShelfView(_ view: FrontPageShelfView, didSelectSavedSearchItem item: SavedSearchShelfViewModel)
    func frontPageShelfView(_ view: FrontPageShelfView, didSelectHeaderForSection section: FrontPageShelfView.Section)
   
}

public class FrontPageShelfView: UIView {
    static let topPadding: CGFloat = .spacingL
    static let headerHeight: CGFloat = 44
    static let favoriteCellHeight: CGFloat = 200
    static let savedSearchCellHeight: CGFloat = 100
    static let sectionSpacing: CGFloat = .spacingL

    typealias Datasource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    public enum Section: Int, CaseIterable {
        case savedSearch
        case recentlyFavorited
    }

    private var collectionViewDatasource: Datasource!
    private var items: [Section: [AnyHashable]] = [:]
    private weak var shelfDatasource: FrontPageShelfViewDataSource?
    public weak var shelfDelegate: FrontPageShelfDelegate?
    private var scrollToSavedSearchIndexPath: IndexPath?

    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .savedSearch:
                if let items = self?.items[section, default: []], items.isEmpty {
                    fallthrough
                }
                return self?.savedSearchLayout
            case .recentlyFavorited: return self?.favoriteLayout
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Self.sectionSpacing
        layout.configuration = config
        return layout
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()

    public init(withDatasource datasource: FrontPageShelfViewDataSource) {
        self.shelfDatasource = datasource
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

// MAKR: - Public method
public extension FrontPageShelfView {
    func removeItem(_ item: AnyHashable) {
        var snapshot = collectionViewDatasource.snapshot()
        snapshot.deleteItems([item])
        var favorites =  items[.recentlyFavorited, default: []]
        
        if let index = favorites.firstIndex(of: item) {
            favorites.remove(at: index)
            items[.recentlyFavorited] = favorites
        }
        
        if favorites.isEmpty {
            snapshot.deleteSections([.recentlyFavorited])
        }
        
        collectionViewDatasource.apply(snapshot, animatingDifferences: true)
    }

    func reloadShelf() {
        applySnapshot()
    }

    func scrollToSavedSearch(atIndex index: Int) {
        scrollToSavedSearchIndexPath = IndexPath(item: index, section: Section.savedSearch.rawValue)
        setNeedsLayout()
    }
}

// MARK: - Setup
private extension FrontPageShelfView {
    func setup() {
        addSubview(collectionView)
        registerCollectionViewCells()
        
        collectionView.backgroundColor = .bgQuaternary
        collectionView.fillInSuperview()
        collectionViewDatasource = makeDatasource()
    }

    func registerCollectionViewCells() {
        shelfDatasource?.frontPageShelfView(cellClassesIn: collectionView).forEach { [weak self] cell in
            self?.collectionView.register(cell)
        }
        collectionView.register(FrontPageShelfHeaderView.self, ofKind: FrontPageShelfHeaderView.reuseIdentifier)
    }
}

// MARK: - Layout
private extension FrontPageShelfView {
    private var favoriteLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Self.favoriteCellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .estimated(Self.favoriteCellHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: .spacingS)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous

        //Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Self.headerHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageShelfHeaderView.reuseIdentifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]

        return section
    }

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
private extension FrontPageShelfView {
    private func makeDatasource() -> Datasource {
        let datasource = Datasource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            self?.shelfDatasource?.frontPageShelfView(collectionView, cellForItemAt: indexPath, withItem: item)
            
        }
        
        datasource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard
                let self = self,
                  let datasource = self.shelfDatasource
            else { return nil }
            
            let headerView = collectionView.dequeue(FrontPageShelfHeaderView.self, for: indexPath, ofKind: kind)
            let section = Section.allCases[indexPath.section]
            switch section {
            case .savedSearch:
                if self.items[section, default: []].isEmpty { fallthrough }
                headerView.configureHeaderView(withTitle: datasource.frontPageShelfView(self, titleForSectionAt: Section.savedSearch.rawValue),
                                               buttonTitle: datasource.frontPageShelfView(self, titleForButtonForSectionAt: Section.savedSearch.rawValue),
                                               buttonAction: {
                    
                    self.shelfDelegate?.frontPageShelfView(self, didSelectHeaderForSection: .savedSearch)
                })
                
            case .recentlyFavorited:
                headerView.configureHeaderView(withTitle: datasource.frontPageShelfView(self, titleForSectionAt: Section.recentlyFavorited.rawValue),
                                               buttonTitle: datasource.frontPageShelfView(self, titleForButtonForSectionAt: Section.recentlyFavorited.rawValue),
                                               buttonAction: {
                    self.shelfDelegate?.frontPageShelfView(self, didSelectHeaderForSection: .recentlyFavorited)
                    
                })
            }
            return headerView
        }

        return datasource
    }

    private func applySnapshot() {
        guard let datasource = shelfDatasource else { return }
        var snapshot = Snapshot()
        for section in Section.allCases {
            let datasource = datasource.datasource(forSection: section)
            if datasource.isEmpty { continue }
            items[section] = datasource
            snapshot.appendSections([section])
            snapshot.appendItems(datasource, toSection: section)
        }

        collectionViewDatasource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension FrontPageShelfView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = collectionViewDatasource.itemIdentifier(for: indexPath) else { return }
        if let item = item as? RecentlyFavoritedViewmodel {
            shelfDelegate?.frontPageShelfView(self, didSelectFavoriteItem: item)
        }
        else if let item = item as? SavedSearchShelfViewModel {
            shelfDelegate?.frontPageShelfView(self, didSelectSavedSearchItem: item)
        }
    }
}

