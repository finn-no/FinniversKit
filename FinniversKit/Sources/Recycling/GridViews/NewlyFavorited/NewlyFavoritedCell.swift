//
//  NewlyFavoritedCell.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 11/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit
public struct NewlyFavorited: FavoritesListViewModel {
    public var imagePath: String?
    public var imageSize: CGSize
    public var detail: String
    public var title: String
}

public class NewlyFavoritedFlowLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach({ layoutAttribute in
            layoutAttribute.frame.origin.y = 0
        })
        
        return attributes
    }
}

public class NewlyFavoritedCell: UICollectionViewCell {
    static let identifier = "NewlyFavoritedCell"
    
    private lazy var collectionView: UICollectionView = {
        let flow = NewlyFavoritedFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 8
        flow.sectionInset = UIEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 40)
        flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NewlyFavoritedItemCell.self)
        collectionView.backgroundColor = .bgTertiary
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension NewlyFavoritedCell {
    private func setup() {
        contentView.addSubview(collectionView)
        collectionView.fillInSuperview()
        
        
    }
}

extension NewlyFavoritedCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewlyFavoritedItemCell.self, for: indexPath)
        return cell
    }
}
