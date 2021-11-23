
import FinniversKit

class SavedSearchShelfDemoView: UIView {
    typealias Datasource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    enum Section: CaseIterable {
        case savedSearch
    }
    
    private var items: [SavedSearchShelfViewModel] = []
    
    private var datasource: Datasource!
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { _,_ in
            return self.recentlySavedLayout
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SavedSearchShelfCell.self)
        collectionView.register(FrontPageShelfHeaderView.self, forSupplementaryViewOfKind: FrontPageShelfHeaderView.reuseIdentifier, withReuseIdentifier: FrontPageShelfHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        items = SavedSearchShelfFactory.create(numberOfItems: 8)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension SavedSearchShelfDemoView {
    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
        collectionView.backgroundColor = .bgPrimary
        datasource = makeDatasource()
        applySnapshot()
    }
}

//MARK: - Layout
private extension SavedSearchShelfDemoView {
    
    private var recentlySavedLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .estimated(100))
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

// MARK: - DataSource
private extension SavedSearchShelfDemoView {
    private func makeDatasource() -> Datasource {
        let datasource = Datasource(collectionView: collectionView) { (collectionView, indexPath, item) in
            let cell =  collectionView.dequeue(SavedSearchShelfCell.self, for: indexPath)
            cell.configure(withModel: self.items[indexPath.item])
            return cell
        }
        
        datasource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FrontPageShelfHeaderView.reuseIdentifier, for: indexPath) as? FrontPageShelfHeaderView {
                
                headerView.configureHeaderView(withTitle: "Nyeste Lagrede", buttonTitle: "se alle") {
                    print("Header was pressed")
                }
                return headerView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        return datasource
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.savedSearch])
        snapshot.appendItems(items, toSection: .savedSearch)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
