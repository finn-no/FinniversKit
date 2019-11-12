//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import Sparkle

final class FavoriteFoldersListDemoView: UIView, Tweakable {
    private var allFavorites = FavoriteFoldersFactory.create() { didSet { filterFolders() } }
    private var filteredFavorites = [FavoriteFolder]()
    private var filterString = ""
    private var isEditing = false
    private let viewModel = FavoriteFoldersListViewModel(
        searchBarPlaceholder: "Søk etter en av dine lister",
        addFolderText: "Lag ny liste",
        emptyViewBodyPrefix: "Du har ingen lister med navnet",
        isEditable: true
    )

    private(set) lazy var view: FavoriteFoldersListView = {
        let view = FavoriteFoldersListView(viewModel: viewModel)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    lazy public var tweakingOptions: [TweakingOption] = {
        return [
            TweakingOption(title: "Toggle mode", description: nil) { [weak self] in
                self?.isEditing = false
                self?.allFavorites = FavoriteFoldersFactory.create()
                self?.view.setEditing(false)
                self?.view.hideXmasButton()
            },
            TweakingOption(title: "Edit mode", description: nil) { [weak self] in
                self?.isEditing = true
                self?.allFavorites = FavoriteFoldersFactory.create(withSelectedItems: false)
                self?.view.setEditing(true)
                self?.view.hideXmasButton()
            },
            TweakingOption(title: "Xmas button", description: nil) { [weak self] in
                let text = "Tips! Nå kan du endelig opprette og dele din egen juleønskeliste! Her er i såfall knappen for å gjøre det! God jul!"
                self?.view.showXmasButton(withCalloutText: text)
            }
        ]
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
    func favoriteFoldersListViewDidBeginRefreshing(_ view: FavoriteFoldersListView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak view] in
            view?.reloadData()
        })
    }

    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didSelectItemAtIndex index: Int) {
        guard !isEditing else {
            return
        }

        let folderId = filteredFavorites[index].id
        guard let folderIndex = allFavorites.firstIndex(where: { $0.id == folderId }) else { return }

        allFavorites[folderIndex].isSelected.toggle()
        view.reloadRow(at: index)
    }

    func favoriteFoldersListView(_ view: FavoriteFoldersListView, didChangeSearchText searchText: String) {
        filterString = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        filterFolders()
        view.reloadData()
    }

    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didDeleteItemAtIndex index: Int) {}
    func favoriteFoldersListViewDidSelectAddButton(_ view: FavoriteFoldersListView, withSearchText searchText: String?) {}

    func favoriteFoldersListViewDidFocusSearchBar(_ view: FavoriteFoldersListView) {
        // Set bottomSheet to expanded here, if needed.
    }

    func favoriteFoldersListViewDidSelectXmasButton(_ view: FavoriteFoldersListView) {
        view.hideXmasButton()
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
                                        loadImageWithPath imagePath: String,
                                        imageWidth: CGFloat,
                                        completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
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

    func favoriteFoldersListView(_ view: FavoriteFoldersListView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
