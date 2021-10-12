
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class FrontPageShelfLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach({ layoutAttribute in
            layoutAttribute.frame.origin.y = 0
        })

        return attributes
    }
}

public protocol FrontpageFavoritedShelfDatasource: AnyObject {
    func numberOfItems(_ favoritedShelf: FrontPageFavoritedShelfCell) -> Int
    func favoritedShelf( _ favoritedShelf: FrontPageFavoritedShelfCell, modelAtIndex index: Int) -> FavoritedShelfViewModel
    func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, loadImageForModel model: FavoritedShelfViewModel, completion: @escaping(UIImage?) -> Void)
}

public protocol FrontpageFavoritedShelfDelegate: AnyObject {
    func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, didSelectItem item: FavoritedShelfViewModel)
    func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, didFavoriteItem item: FavoritedShelfViewModel, onCollectionView collectionView: UICollectionView)
    func favoritedShelf(_ favoritedShelf: FrontPageFavoritedShelfCell, didUnfavoriteItem item: FavoritedShelfViewModel, onCollectionView collectionView: UICollectionView)
}

public class FrontPageFavoritedShelfCell: UICollectionViewCell {
    static let identifier = "FrontPageFavoritedShelfCell"
    
    private lazy var collectionView: UICollectionView = {
        let flow = FrontPageShelfLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 8
        flow.sectionInset = UIEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 40)
        flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FrontpageFavoritedShelfItemCell.self)
        collectionView.backgroundColor = .bgTertiary
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public var dataSource: FrontpageFavoritedShelfDatasource?
    public var delegate: FrontpageFavoritedShelfDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension FrontPageFavoritedShelfCell {
    private func setup() {
        contentView.addSubview(collectionView)
        collectionView.fillInSuperview()
    }
    
    private func cell(cell: FrontpageFavoritedShelfItemCell, atIndex index: Int, didToggleFavoriteButton status: Bool) {
        guard let model = cell.model, let delegate = self.delegate else {
            return
        }
        
        if status {
            delegate.favoritedShelf(self, didFavoriteItem: model, onCollectionView: self.collectionView)
        } else {
            delegate.favoritedShelf(self, didUnfavoriteItem: model, onCollectionView: self.collectionView)
        }
    }
}

extension FrontPageFavoritedShelfCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(FrontpageFavoritedShelfItemCell.self, for: indexPath)
        
        if let model = dataSource?.favoritedShelf(self, modelAtIndex: indexPath.item) {
            cell.model = model
        }
        
        cell.favoriteToggleAction = { [weak self] favoriteButton in
            self?.cell(cell: cell, atIndex: indexPath.item, didToggleFavoriteButton: favoriteButton.isToggled)
        }
        return cell
    }
}

extension FrontPageFavoritedShelfCell: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource?.favoritedShelf(self, modelAtIndex: indexPath.item) else {
            return
        }
        
        delegate?.favoritedShelf(self, didSelectItem: model)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? FrontpageFavoritedShelfItemCell,
              let model = cell.model,
              let dataSource = dataSource
        else {
            return
        }
        
        dataSource.favoritedShelf(self, loadImageForModel: model) { image in
            cell.setImage(image)
        }
    }
}
