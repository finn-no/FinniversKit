//
//  NewlyFavoritedCell.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 11/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

class NewlyFavoritedCell: UICollectionViewCell {
    static let identifier = "NewlyFavoritedCell"

    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: 128 + 4, height: 200)
        flow.minimumInteritemSpacing = 8
        flow.sectionInset = UIEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewlyFavoritedItemCell.self, for: indexPath)
        return cell
    }
}
