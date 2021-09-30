//
//  NewFrontPage.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 28/09/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public enum Section {
    case favorites
}

public typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>

public class NewFrontPageView: UIView {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private let headerKind = "FrontPageHaderViewKind"
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FrontpageFavoritedShelfItemCell.self, forCellWithReuseIdentifier: FrontpageFavoritedShelfItemCell.identifier)
        collectionView.register(FrontPageHeaderView.self, forSupplementaryViewOfKind: FrontPageHeaderView.identifier, withReuseIdentifier: FrontPageHeaderView.identifier)
        
        return collectionView
    }()
    
    let compositionalLayout: UICollectionViewCompositionalLayout = {
        // Item
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
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private lazy var dataSource = makeDataSource()
    public var items: [FavoritedShelfViewModel] = [] {
        didSet {
            self.applySnapshot()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrontpageFavoritedShelfItemCell.identifier, for: indexPath) as? FrontpageFavoritedShelfItemCell
            let item = self?.items[indexPath.row]
            cell?.model = item
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FrontPageHeaderView.identifier, for: indexPath) as? FrontPageHeaderView {
                headerView.configureHeaderView(withTitle: "Nyeste favoritter", buttonTitle: "se alle") {
                    
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
        snapshot.appendSections([.favorites])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
