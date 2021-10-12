//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit
import SwiftUI

public enum Section: CaseIterable {
    case recentlySaved
    case favorites
    case grid
}

public typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>

public class NewFrontPageView: UIView {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FrontpageFavoritedShelfItemCell.self, forCellWithReuseIdentifier: FrontpageFavoritedShelfItemCell.identifier)
        collectionView.register(RecentlySavedCell.self, forCellWithReuseIdentifier: RecentlySavedCell.identifier)
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
        collectionView.register(FrontPageHeaderView.self, forSupplementaryViewOfKind: FrontPageHeaderView.identifier, withReuseIdentifier: FrontPageHeaderView.identifier)
        
        return collectionView
    }()
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .favorites:
                return self.recentlyFavoritedLayout
            case .recentlySaved:
                return self.recentlySavedLayout
            case .grid:
                return self.gridLayout
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }()
    
    private lazy var recentlyFavoritedLayout: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading:0, bottom: 0, trailing: 8)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageHeaderView.identifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        return section
    }()
    
    private lazy var recentlySavedLayout: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading:0, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: FrontPageHeaderView.identifier, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        return section
    }()
    
    private lazy var gridLayout: NSCollectionLayoutSection = {
        var leadingGroupItems = [NSCollectionLayoutItem]()
        var trailingGroupItems = [NSCollectionLayoutItem]()
        var leadinGroupHeight: CGFloat = 0
        var trailingGroupHeight: CGFloat = 0
        
        let totalHeight = self.gridItems.reduce(0) { $0 + $1.height + 8 }
        let columnHeight = CGFloat(totalHeight / 2.0)
        
        var leadingHeight = CGFloat(0)
        var trailingHeight = CGFloat(0)
        
        for (index, gridItem) in gridItems.enumerated() {
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(gridItem.height))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(all: 4)
            let isLeading =  leadingHeight < trailingHeight || leadingHeight == 0
            
            print("index: \(index)", "Should be leading: \(index % 2 == 0)")
            if isLeading {
                leadingGroupItems.append(item)
                leadinGroupHeight += gridItem.height + 8
                leadingHeight += gridItem.height + 8
            } else {
                trailingGroupItems.append(item)
                trailingGroupHeight += gridItem.height + 8
                trailingHeight += gridItem.height + 8
            }
        }
        
        let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(leadinGroupHeight))
        let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize, subitems: leadingGroupItems)
        
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(trailingGroupHeight))
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitems: trailingGroupItems)
        
        let containerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(max(leadinGroupHeight, trailingGroupHeight)))
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerSize, subitems: [leadingGroup, trailingGroup])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        return section
    }()
    
    
    
    private lazy var dataSource = makeDataSource()
    
    public var items: [FavoritedShelfViewModel] = [] {
        didSet {
            self.applySnapshot()
        }
    }
    
    public var savedItems: [RecentlySavedViewModel] = {
        [
            RecentlySavedViewModel(id: "1", title: "Test"),
            RecentlySavedViewModel(id: "2", title: "Test"),
            RecentlySavedViewModel(id: "3", title: "Test"),
            RecentlySavedViewModel(id: "4", title: "Test"),
            RecentlySavedViewModel(id: "5", title: "Test"),
            RecentlySavedViewModel(id: "6", title: "Test"),
            RecentlySavedViewModel(id: "7", title: "Test"),
            RecentlySavedViewModel(id: "8", title: "Test")
        ]
    }()
    
    public var gridItems: [GridViewModel] {
        let source = (1...17).map { GridViewModel.init(index: $0) }
        let pairs = source.enumerated().compactMap { index, element in
            index % 2 == 0 ? element : nil
        }
        
        let odds = source.filter { !pairs.contains($0) }
        
        return odds + pairs
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Layouts
private extension NewFrontPageView {

}

private extension NewFrontPageView {
    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
        applySnapshot()
        print("Hello")
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            if let _ = item as? FavoritedShelfViewModel {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrontpageFavoritedShelfItemCell.identifier, for: indexPath) as? FrontpageFavoritedShelfItemCell
                let item = self?.items[indexPath.row]
                cell?.model = item
                return cell
            } else if let _ = item as? RecentlySavedViewModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlySavedCell.identifier, for: indexPath) as? RecentlySavedCell
                return cell
            } else if let _ = item as? GridViewModel, let model = self?.gridItems[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.identifier, for: indexPath) as? GridCell
                cell?.configure(withModel: model)
                return cell
            }
            return nil
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FrontPageHeaderView.identifier, for: indexPath) as? FrontPageHeaderView {
                
                headerView.configureHeaderView(withTitle: indexPath.section == 0 ? "Nylig Lagrede": "Nyeste Favoritter", buttonTitle: "se alle") {
                    
                }
                return headerView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.recentlySaved])
        snapshot.appendItems(savedItems)
        
        snapshot.appendSections([.favorites])
        snapshot.appendItems(items)
        
        snapshot.appendSections([.grid])
        snapshot.appendItems(gridItems)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
