import UIKit

public class FrontPageShelfView: UIView {
    typealias Datasource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    enum Section: CaseIterable {
        case savedSearch
        case recentlyFavorited
    }
    
    private var datasource: Datasource!
    private var items = [1,2,3,4,5,6]
    private var items2 = [7,8,9,10,11]
    
    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .savedSearch: return self.savedSearchLayout
            case .recentlyFavorited: return self.favoriteLayout
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SavedSearchShelfCell.self)
        collectionView.register(RecentlyFavoritedShelfCell.self)
        collectionView.register(FrontPageShelfHeaderView.self,
                                forSupplementaryViewOfKind: FrontPageShelfHeaderView.reuseIdentifier,
                                withReuseIdentifier: FrontPageShelfHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(collectionView)
        collectionView.backgroundColor = .bgPrimary
        collectionView.fillInSuperview()
        datasource = makeDatasource()
        applySnapshot()
    }
    
}

//MARK: - Layout
private extension FrontPageShelfView {
    private var favoriteLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: .spacingS)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingL, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        
        //Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageShelfHeaderView.reuseIdentifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        
        return section
    }
    
    private var savedSearchLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .estimated(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading:0, bottom: 0, trailing: 16)
        
        //Sections
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageShelfHeaderView.reuseIdentifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        
        return section
    }
}

//MARK: - Datasource
private extension FrontPageShelfView {
    private func makeDatasource() -> Datasource {
        let datasource = Datasource(collectionView: collectionView) { collectionView, indexPath, item in
            print(indexPath.section)
            let section = Section.allCases[indexPath.section]
            print(section)
            switch section {
            case .recentlyFavorited:
                return collectionView.dequeue(RecentlyFavoritedShelfCell.self, for: indexPath)
            case .savedSearch:
                return collectionView.dequeue(SavedSearchShelfCell.self, for: indexPath)
            }
        }
        
        datasource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let headerView = collectionView.dequeue(FrontPageShelfHeaderView.self, for: indexPath, ofKind: kind)
            let section = Section.allCases[indexPath.section]
            switch section {
            case .recentlyFavorited:
                headerView.configureHeaderView(withTitle: "Nylige favoritter", buttonTitle: "Se alle", buttonAction: { print("Se alle favoritter" )})
            case .savedSearch:
                headerView.configureHeaderView(withTitle: "Lagrede søk", buttonTitle: "Se alle", buttonAction: { print("Se alle lagrede søk")})
            }
            return headerView
        }
        
        return datasource
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.savedSearch])
        snapshot.appendItems(items, toSection: .savedSearch)
        
        snapshot.appendSections([.recentlyFavorited])
        snapshot.appendItems(items2, toSection: .recentlyFavorited)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
