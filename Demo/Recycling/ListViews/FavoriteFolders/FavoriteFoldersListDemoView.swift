//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFoldersListDemoView: UIView {
    private let allFavorites = FavoriteFoldersFactory.create()
    private var filteredFavorites = [FavoriteFolderViewModel]()

    private let viewModel = FavoriteFoldersListViewModel(
        searchBarPlaceholder: "Søk etter en av dine lister",
        addFolderText: "Lag ny liste",
        cancelButtonTitle: "Avbryt"
    )

    private lazy var view: FavoriteFoldersListView = {
        let view = FavoriteFoldersListView(viewModel: viewModel)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        filteredFavorites = allFavorites
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }

    private func reload(with items: [FavoriteFolderViewModel]) {
        filteredFavorites = items
        view.reloadData()
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteFoldersListDemoView: FavoriteFoldersListViewDelegate {
    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didSelectItemAtIndex index: Int) {}

    func favoriteFoldersListView(_ view: FavoriteFoldersListView, didChangeSearchText searchText: String) {
        let items = searchText.isEmpty
            ? allFavorites
            : allFavorites.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
        reload(with: items)
    }

    func favoriteFoldersListViewDidCancelSearch(_ view: FavoriteFoldersListView) {
        reload(with: allFavorites)
    }
}

// MARK: - FavoriteFoldersListViewDataSource

extension FavoriteFoldersListDemoView: FavoriteFoldersListViewDataSource {
    func numberOfItems(inFavoriteFoldersListView favoriteFoldersListView: FavoriteFoldersListView) -> Int {
        return filteredFavorites.count
    }

    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView,
                                 viewModelAtIndex index: Int) -> FavoriteFolderViewModel {
        return filteredFavorites[index]
    }

    public func favoriteFoldersListView(_ view: FavoriteFoldersListView,
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

    func favoriteFoldersListView(_ view: FavoriteFoldersListView,
                                 cancelLoadingImageForModel model: RemoteImageTableViewCellViewModel) {}
}
