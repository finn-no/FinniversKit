//
//  FavoritedShelfDemoView.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 16/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import FinniversKit

public class FavoritedShelfDataSource: NSObject {
    var favorites = FavoritedShelfFactory.create()
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
        cell.delegate = self
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

extension FavoritedShelfDemoView: FrontpageFavoritedShelfDelegate {
    public func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, didSelectItem item: FavoritedShelfViewModel) {
        print("Selected Item: \(item)")
    }
    
    public func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, didFavoriteItem item: FavoritedShelfViewModel, onCollectionView collectionView: UICollectionView) {
        print("User did favorite item: \(item)")
    }
    
    public func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, didUnfavoriteItem item: FavoritedShelfViewModel, onCollectionView collectionView: UICollectionView) {
        print("User did unfavorite item: \(item)")
        guard let index  = dataSource.favorites.firstIndex(where: {
            $0.adId == item.adId
        }) else {
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        self.dataSource.favorites.remove(at: index)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [indexPath])
        } completion: { completion in
            print("Item deleted")
        }
    }
}
