//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFoldersListViewDemoView: UIView {
    private let favorites = FavoriteFoldersFactory.create()

    private lazy var view: FavoriteFoldersListView = {
        let view = FavoriteFoldersListView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteFoldersListViewDemoView: FavoriteFoldersListViewDelegate {
    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didSelectItemAtIndex index: Int) {}
}

extension FavoriteFoldersListViewDemoView: FavoriteFoldersListViewDataSource {
    func numberOfItems(inFavoriteFoldersListView favoriteFoldersListView: FavoriteFoldersListView) -> Int {
        return favorites.count
    }

    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView,
                                 viewModelAtIndex index: Int) -> FavoriteFoldersListViewModel {
        return favorites[index]
    }

    public func remoteImageTableViewCell(_ cell: RemoteImageTableViewCell,
                                         loadImageForModel model: RemoteImageTableViewCellViewModel,
                                         completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
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

    func remoteImageTableViewCell(_ cell: RemoteImageTableViewCell,
                                  cancelLoadingImageForModel model: RemoteImageTableViewCellViewModel) {}
}


//final class FavoriteFoldersListViewController: DemoViewController<FavoriteFoldersListView> {
//    private let searchController = UISearchController(searchResultsController: nil)
//    private let favorites = FavoriteFoldersFactory.create()
//
//    private lazy var foldersView: FavoriteFoldersListView = {
//        let view = FavoriteFoldersListView(withAutoLayout: true)
//        view.dataSource = self
//        view.delegate = self
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(foldersView)
//        foldersView.fillInSuperview()
//
//        navigationItem.title = "Velg liste"
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Søk etter en av dine lister"
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//            navigationItem.hidesSearchBarWhenScrolling = false
//        } else {
//            navigationItem.titleView = searchController.searchBar
//        }
//        definesPresentationContext = true
//    }
//}
//
//extension FavoriteFoldersListViewController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        // TODO
//    }
//}
//
//// MARK: - FavoriteFoldersListViewDelegate
//
//extension FavoriteFoldersListViewController: FavoriteFoldersListViewDelegate {
//    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didSelectItemAtIndex index: Int) {}
//}
//
//extension FavoriteFoldersListViewController: FavoriteFoldersListViewDataSource {
//    func numberOfItems(inFavoriteFoldersListView favoriteFoldersListView: FavoriteFoldersListView) -> Int {
//        return favorites.count
//    }
//
//    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView,
//                                 viewModelAtIndex index: Int) -> FavoriteFoldersListViewModel {
//        return favorites[index]
//    }
//
//    public func remoteImageTableViewCell(_ cell: RemoteImageTableViewCell,
//                                         loadImageForModel model: RemoteImageTableViewCellViewModel,
//                                         completion: @escaping ((UIImage?) -> Void)) {
//        guard let path = model.imagePath, let url = URL(string: path) else {
//            completion(nil)
//            return
//        }
//
//        // Demo code only.
//        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
//            usleep(50_000)
//            DispatchQueue.main.async {
//                if let data = data, let image = UIImage(data: data) {
//                    completion(image)
//                } else {
//                    completion(nil)
//                }
//            }
//        }
//
//        task.resume()
//    }
//
//    func remoteImageTableViewCell(_ cell: RemoteImageTableViewCell,
//                                  cancelLoadingImageForModel model: RemoteImageTableViewCellViewModel) {}
//}
