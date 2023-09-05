//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

/// For use with FavoritesListView.
class FavoriteDataSource: NSObject {
    let favorites = FavoriteFactory.create()
}

class FavoritesListViewDemoView: UIView, Demoable {
    lazy var dataSource: FavoriteDataSource = {
        return FavoriteDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = FavoritesListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension FavoritesListViewDemoView: FavoritesListViewDelegate {
    func favoritesListView(_ favoritesListView: FavoritesListView, didSelectItemAtIndex index: Int) {}
    func favoritesListView(_ favoritesListView: FavoritesListView, willDisplayItemAtIndex index: Int) {}
    func favoritesListView(_ favoritesListView: FavoritesListView, didScrollInScrollView scrollView: UIScrollView) {}
}

extension FavoritesListViewDemoView: FavoritesListViewDataSource {
    func numberOfItems(inFavoritesListView favoritesListView: FavoritesListView) -> Int {
        return dataSource.favorites.count
    }

    func favoritesListView(_ favoritesListView: FavoritesListView, modelAtIndex index: Int) -> FavoritesListViewModel {
        return dataSource.favorites[index]
    }

    func favoritesListView(_ favoritesListView: FavoritesListView, loadImageForModel model: FavoritesListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    func favoritesListView(_ favoritesListView: FavoritesListView, cancelLoadingImageForModel model: FavoritesListViewModel, imageWidth: CGFloat) {}
}
