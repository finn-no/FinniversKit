import UIKit

public protocol FrontPageShelfViewDataSource {
    func frontPageShelfView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell?
    func frontPageShelfView(cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func datasource(forSection section: FrontPageShelfView.Section) -> [AnyHashable]
}

public protocol FrontPageShelfDelegate: AnyObject {
    func frontPageShelfView(_ collectionView: UICollectionView, didSelectItem item: AnyHashable)
}

public class FrontPageShelfView: UIView {
    typealias Datasource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    public enum Section: CaseIterable {
        case savedSearch
        case recentlyFavorited
    }
    
    private var collectionViewDatasource: Datasource!
    private var items: [Section: [AnyHashable]] = [:]
    private var shelfDatasource: FrontPageShelfViewDataSource
    public weak var shelfDelegate: FrontPageShelfDelegate?
    
    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .savedSearch:
                if self.items[section, default: []].isEmpty {
                    fallthrough
                }
                return self.savedSearchLayout
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
}

// MAKR: - Public method
public extension FrontPageShelfView {
    func removeItem(_ item: AnyHashable) {
        var snapshot = collectionViewDatasource.snapshot()
        snapshot.deleteItems([item])
        collectionViewDatasource.apply(snapshot, animatingDifferences: true)
    }
    
    func reloadShelf() {
        collectionViewDatasource = makeDatasource()
        applySnapshot()
    }
}

// MARK: - Setup
private extension FrontPageShelfView {
    func setup() {
        addSubview(collectionView)
        registerCollectionViewCells()
        
        collectionView.backgroundColor = .bgPrimary
        collectionView.fillInSuperview()
        collectionViewDatasource = makeDatasource()
        applySnapshot()
    }
    
    func registerCollectionViewCells() {
        shelfDatasource.frontPageShelfView(cellClassesIn: collectionView).forEach { cell in
            self.collectionView.register(cell)
        }
        collectionView.register(FrontPageShelfHeaderView.self, ofKind: FrontPageShelfHeaderView.reuseIdentifier)
    }
}

//MARK: - Layout
private extension FrontPageShelfView {
    private var favoriteLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .estimated(180))
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
        let datasource = Datasource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            self?.shelfDatasource.frontPageShelfView(collectionView, cellForItemAt: indexPath, withItem: item)
            
        }
        
        datasource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let headerView = collectionView.dequeue(FrontPageShelfHeaderView.self, for: indexPath, ofKind: kind)
            let section = Section.allCases[indexPath.section]
            switch section {
            case .savedSearch:
                if self.items[section, default: []].isEmpty { fallthrough }
                headerView.configureHeaderView(withTitle: "Lagrede søk", buttonTitle: "Se alle", buttonAction: { print("Se alle lagrede søk")})
            case .recentlyFavorited:
                headerView.configureHeaderView(withTitle: "Nylige favoritter", buttonTitle: "Se alle", buttonAction: { print("Se alle favoritter" )})
            }
            return headerView
        }
        
        return datasource
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        for section in Section.allCases {
            let datasource = shelfDatasource.datasource(forSection: section)
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
        shelfDelegate?.frontPageShelfView(collectionView, didSelectItem: item)
    }
}

