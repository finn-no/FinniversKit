//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

final class FavoriteFoldersListDemoView: UIView {
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

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        filteredFavorites = allFavorites
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

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

extension FavoriteFoldersListDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case toggleMode
        case editMode
        case xmasButton
    }

    var shouldSnapshotTweaks: Bool { false }
    var presentation: DemoablePresentation { .navigationController }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .toggleMode:
            isEditing = false
            allFavorites = FavoriteFoldersFactory.create()
            view.setEditing(false)
            view.hideXmasButton()
        case .editMode:
            isEditing = true
            allFavorites = FavoriteFoldersFactory.create(withSelectedItems: false)
            view.setEditing(true)
            view.hideXmasButton()
        case .xmasButton:
            let text = "Tips! Nå kan du endelig opprette og dele din egen juleønskeliste! Her er i såfall knappen for å gjøre det! God jul!"
            view.showXmasButton(withCalloutText: text)
        }
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

    func favoriteFoldersListView(_ view: FavoriteFoldersListView,
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
