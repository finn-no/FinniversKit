//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFoldersListDemoView: UIView, Tweakable {
    private var allFavorites = FavoriteFoldersFactory.create() { didSet { filterFolders() } }
    private var filteredFavorites = [FavoriteFolder]()
    private var filterString = ""
    private let viewModel = FavoriteFoldersListViewModel(
        searchBarPlaceholder: "Søk etter en av dine lister",
        addFolderText: "Lag ny liste",
        emptyViewBodyPrefix: "Du har ingen lister med navnet"
    )

    private(set) lazy var view: FavoriteFoldersListView = {
        let view = FavoriteFoldersListView(viewModel: viewModel)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = {
        var options = [TweakingOption]()

        options.append(TweakingOption(title: "Toggle mode", description: nil) { [weak self] in
            self?.filterString = ""
            self?.allFavorites = FavoriteFoldersFactory.create()
            self?.view.setEditing(false)
        })

        options.append(TweakingOption(title: "Edit mode", description: nil) { [weak self] in
            self?.filterString = ""
            self?.allFavorites = FavoriteFoldersFactory.create(withSelectedItems: false)
            self?.view.setEditing(true)
        })

        return options
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

    private func filterFolders() {
        filteredFavorites = filterString.isEmpty
            ? allFavorites
            : allFavorites.filter({ $0.title.lowercased().contains(filterString) })
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteFoldersListDemoView: FavoriteFoldersListViewDelegate {
    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView,
                                 didSelectItemAtIndex index: Int) {
        let folderId = filteredFavorites[index].id
        guard let folderIndex = allFavorites.firstIndex(where: { $0.id == folderId }) else { return }
        allFavorites[folderIndex].isSelected.toggle()
        view.reloadRow(at: index)
    }

    func favoriteFoldersListViewDidSelectAddButton(_ view: FavoriteFoldersListView) {}
    func favoriteFoldersListViewDidSelectAddButton(_ view: FavoriteFoldersListView, withSearchText searchText: String) {}

    func favoriteFoldersListView(_ view: FavoriteFoldersListView, didChangeSearchText searchText: String) {
        filterString = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        filterFolders()
        view.reloadData()
    }

    func favoriteFoldersListViewDidFocusSearchBar(_ view: FavoriteFoldersListView) {
        // Set bottomSheet to expanded here, if needed.
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
