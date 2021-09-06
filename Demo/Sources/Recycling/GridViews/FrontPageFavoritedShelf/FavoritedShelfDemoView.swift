//
//  FavoritedShelfDemoView.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 16/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import FinniversKit

public class FavoritedShelfDataSource: NSObject {
    let favorites = FavoritedShelfFactory.create()
}

public class FavoritedShelfDemoView: UIView {
    
    lazy var dataSource: FavoritedShelfDataSource = {
        return FavoritedShelfDataSource()
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FrontPageFavoritedShelfCell.self)
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
}

extension FavoritedShelfDemoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FrontPageFavoritedShelfCell = collectionView.dequeue(FrontPageFavoritedShelfCell.self, for: indexPath)
        cell.dataSource = self
        
        return cell
    }
}

extension FavoritedShelfDemoView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 250)
    }
}

extension FavoritedShelfDemoView: FrontpageFavoritedShelfDatasource {
    
    public func numberOfItems(_ favoritedShelf: FrontPageFavoritedShelfCell) -> Int {
        return dataSource.favorites.count
    }
    
    public func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, modelAtIndex index: Int) -> FavoritedShelfViewModel {
        return dataSource.favorites[index]
    }
    
    public func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, loadImageForModel model: FavoritedShelfViewModel, completion: @escaping (UIImage?) -> Void) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , _ in
            
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
}
