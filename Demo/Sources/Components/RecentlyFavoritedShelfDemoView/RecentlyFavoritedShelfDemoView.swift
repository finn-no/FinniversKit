import FinniversKit

class RecentlyFavoritedShelfDemoView: UIView {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private var items: [RecentlyFavoritedViewmodel] = []
    
    enum Section: CaseIterable {
        case recentlyFavorited
    }
    
    private var datasource: DataSource!
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout { _,_  in
            return self.favoriteLayout
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RecentlyFavoritedShelfCell.self)
        collectionView.register(FrontPageShelfHeaderView.self,
                                forSupplementaryViewOfKind: FrontPageShelfHeaderView.reuseIdentifier,
                                withReuseIdentifier: FrontPageShelfHeaderView.reuseIdentifier)
        collectionView.delegate = self
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
        collectionView.fillInSuperview()
        items = RecentlyFavoritedFactory.create(numberOfItems: 10)
        datasource = makeDatasource()
        applySnapshot()
    }
}

//MARK: Layout & Datasource
private extension RecentlyFavoritedShelfDemoView {
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
    
    private func makeDatasource() -> DataSource {
        let datasource =  DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard let model = self?.items[indexPath.item] else {
                return nil
            }
            
            let cell = collectionView.dequeue(RecentlyFavoritedShelfCell.self, for: indexPath)
            cell.configure(withModel: model)
            
            cell.buttonAction = { [weak self] model, isFavorited in
                self?.toggleAndRemove(favoriteModel: model, isFavorited: isFavorited, atIndex: indexPath)
            }
            return cell
        }
        
        datasource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FrontPageShelfHeaderView.reuseIdentifier, for: indexPath) as? FrontPageShelfHeaderView {
                
                headerView.configureHeaderView(withTitle: "Nyeste Favoritter", buttonTitle: "se alle") {
                    print("Header was pressed")
                }
                return headerView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
        return datasource
    }
    
    private func toggleAndRemove(favoriteModel model: RecentlyFavoritedViewmodel, isFavorited: Bool, atIndex index: IndexPath) {
        guard let item = datasource.itemIdentifier(for: index) else { return }
        var snapshot = datasource.snapshot()
        snapshot.deleteItems([item])
        items.remove(at: index.item)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapShot = Snapshot()
        snapShot.appendSections([.recentlyFavorited])
        snapShot.appendItems(items, toSection: .recentlyFavorited)
        
        datasource.apply(snapShot, animatingDifferences: animatingDifferences)
    }
}

//MARK: UICollectionViewDelegate
extension RecentlyFavoritedShelfDemoView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cell = cell as? RecentlyFavoritedShelfCell
        else { return }
        
        cell.loadImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cell = cell as? RecentlyFavoritedShelfCell
        else { return }
        
        cell.cancelImageLoading()
    }
}
