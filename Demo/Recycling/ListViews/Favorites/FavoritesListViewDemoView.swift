//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// For use with FavoritesListView.
public class FavoriteDataSource: NSObject {
    let favorites = FavoriteFactory.create()
}

public class FavoritesListViewDemoView: UIView {
    lazy var dataSource: FavoriteDataSource = {
        return FavoriteDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = FavoritesListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension FavoritesListViewDemoView: FavoritesListViewDelegate {
    public func favoritesListView(_ favoritesListView: FavoritesListView, didSelectItemAtIndex index: Int) {}
    public func favoritesListView(_ favoritesListView: FavoritesListView, willDisplayItemAtIndex index: Int) {}
    public func favoritesListView(_ favoritesListView: FavoritesListView, didScrollInScrollView scrollView: UIScrollView) {}
}

extension FavoritesListViewDemoView: FavoritesListViewDataSource {
    public func numberOfItems(inFavoritesListView favoritesListView: FavoritesListView) -> Int {
        return dataSource.favorites.count
    }

    public func favoritesListView(_ favoritesListView: FavoritesListView, modelAtIndex index: Int) -> FavoritesListViewModel {
        return dataSource.favorites[index]
    }

    public func favoritesListView(_ favoritesListView: FavoritesListView, loadImageForModel model: FavoritesListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
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

    public func favoritesListView(_ favoritesListView: FavoritesListView, cancelLoadingImageForModel model: FavoritesListViewModel, imageWidth: CGFloat) {}
}
