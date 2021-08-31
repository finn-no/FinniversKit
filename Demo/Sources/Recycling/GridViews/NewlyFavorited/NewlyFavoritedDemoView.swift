//
//  NewlyFavoritedDemoView.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 16/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import FinniversKit

public class NewlyFavoritedDataSource: NSObject {
    let favorites = FavoriteFactory.create()
}

public class NewlyFavoritedDemoView: UIView {
    
    lazy var dataSource: NewlyFavoritedDataSource = {
        return NewlyFavoritedDataSource()
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NewlyFavoritedCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
        collectionView.backgroundColor = .bgTertiary
        backgroundColor = .bgTertiary
        backgroundColor = .bgTertiary
    }
    
    private func convertToNewFavorited(_ favorite: Favorite) {
        
    }
}

extension NewlyFavoritedDemoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(NewlyFavoritedCell.self, for: indexPath)
    }
}

extension NewlyFavoritedDemoView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 250)
    }
}
