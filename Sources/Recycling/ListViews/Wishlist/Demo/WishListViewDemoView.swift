//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class WishListDataSource: NSObject {
    let wishlist: [WishList] = WishListFactory.create()
}

public class WishListViewDemoView: UIView {
    private lazy var dataSource: WishListDataSource = {
       return WishListDataSource()
    }()
    
    // MARK: - Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setupView() {
        let view = WishListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension WishListViewDemoView: WishListViewDelegate {
    public func wishListView(_ wishListView: WishListView, didSelectItemAtIndex index: Int) {}
    public func wishListView(_ wishListView: WishListView, willDisplayItemAtIndex index: Int) {}
    public func wishListView(_ wishListView: WishListView, didScrollInScrollView scrollView: UIScrollView) {}
}

extension WishListViewDemoView: WishListViewDataSource {
    public func numberOfItems(inWishListView wishListView: WishListView) -> Int {
        return dataSource.wishlist.count
    }
    
    public func wishListView(_ wishListView: WishListView, modelAtIndex index: Int) -> WishListViewModel {
        return dataSource.wishlist[index]
    }
    
    public func wishListViewCell(_ wishlistListViewCell: WishListViewCell, loadImageForModel model: WishListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
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
    
    public func wishListViewCell(_ wishlistListViewCell: WishListViewCell, cancelLoadingImageForModel model: WishListViewModel, imageWidth: CGFloat) {}
}
