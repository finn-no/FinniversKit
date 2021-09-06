//
//  NewlyFavoritedDemoView.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 16/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import FinniversKit

public class NewlyFavoritedDataSource: NSObject {
    let favorites = NewlyFavoritedFactory.create()
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
}

extension NewlyFavoritedDemoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewlyFavoritedCell = collectionView.dequeue(NewlyFavoritedCell.self, for: indexPath)
        cell.dataSource = self
        
        return cell
    }
}

extension NewlyFavoritedDemoView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: 250)
    }
}

extension NewlyFavoritedDemoView: NewlyFavoritedListDataSource {
    public func numberOfItems(_ inNewlyFavoritedListCell: NewlyFavoritedCell) -> Int {
        return dataSource.favorites.count
    }
    
    public func newlyFavoritedListCell(_ newlyFavoritedListCell: NewlyFavoritedCell, modelAtIndex index: Int) -> NewlyFavoritedViewModel {
        return dataSource.favorites[index]
    }
    
    public func newlyFavoritedListCell(_ newlyFavoritedListCell: NewlyFavoritedCell, loadImageForModel model: NewlyFavoritedViewModel, completion: @escaping (UIImage?) -> Void) {
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
