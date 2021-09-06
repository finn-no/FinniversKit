//
//  NewlyFavoritedCell.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 11/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class NewlyFavoritedFlowLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach({ layoutAttribute in
            layoutAttribute.frame.origin.y = 0
        })
        
        return attributes
    }
}

public protocol NewlyFavoritedListDataSource: AnyObject {
    func numberOfItems(_ inNewlyFavoritedListCell: NewlyFavoritedCell) -> Int
    func newlyFavoritedListCell( _ newlyFavoritedListCell: NewlyFavoritedCell, modelAtIndex index: Int) -> NewlyFavoritedViewModel
    func newlyFavoritedListCell(_ newlyFavoritedListCell: NewlyFavoritedCell, loadImageForModel model: NewlyFavoritedViewModel, completion: @escaping(UIImage?) -> Void)
}

public protocol NewlyFavoritedListDelegate: AnyObject {
    func newlyFavoritedListCell(_ newlyFavoritedListCell: NewlyFavoritedCell, didToggleFavoritesButton button: IconButton, atIndex index: Int)
    func newlyFavoritedListCell(_ newlyFavoritedListCell: NewlyFavoritedCell, didSelectItem item: NewlyFavoritedViewModel)
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
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public var dataSource: NewlyFavoritedListDataSource?
    
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
    
    private func cell(cell: NewlyFavoritedItemCell, atIndex index: Int, didToggleFavoriteButton status: Bool) {
        print("user \(status ? "favorited" : "unfavorited") item at index \(index)")
    }
}

extension NewlyFavoritedCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(NewlyFavoritedItemCell.self, for: indexPath)
        
        if let model = dataSource?.newlyFavoritedListCell(self, modelAtIndex: indexPath.item) {
            cell.model = model
        }
        
        cell.favoriteToggleAction = { [weak self] favoriteButton in
            self?.cell(cell: cell, atIndex: indexPath.item, didToggleFavoriteButton: favoriteButton.isToggled)
        }
        
        return cell
    }
}

extension NewlyFavoritedCell: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource?.newlyFavoritedListCell(self, modelAtIndex: indexPath.item) else {
            return
        }
        
        print(model)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NewlyFavoritedItemCell,
              let model = cell.model,
              let dataSource = dataSource
        else {
            return
        }
        
        dataSource.newlyFavoritedListCell(self, loadImageForModel: model) { image in
            cell.setImage(image)
        }
    }
}
