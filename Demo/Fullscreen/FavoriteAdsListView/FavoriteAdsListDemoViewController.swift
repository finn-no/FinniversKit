//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

enum AdsSorting: String {
    case lastAdded = "Sist lagt til"
    case alphabetically = "Alfabetisk"
}

class FavoriteAdsListDemoViewController: DemoViewController<UIView>, Tweakable {

    // MARK: - Private properties

    private let viewModels = FavoriteAdsFactory.create()
    private let sectionDataSource = FavoriteAdsDemoDataSource()
    private var currentSorting: AdsSorting = .lastAdded
    private var folderTitle = "Mine funn"
    private lazy var navigationTitleView = VisibilityDrivenTitleView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 44)))

    private lazy var favoritesListView: FavoriteAdsListView = {
        let view = FavoriteAdsListView(viewModel: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.title = folderTitle
        view.subtitle = "\(viewModels.count) favoritter"
        view.sortingTitle = currentSorting.rawValue
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "Selection mode", description: nil) { [weak self] in
                self?.resetViewModels()
                self?.setReadOnly(false)
                self?.favoritesListView.setEditing(false)
                self?.resetHeader()
            },
            TweakingOption(title: "Selection mode", description: "Title with 50 characters") { [weak self] in
                self?.resetViewModels()
                self?.setReadOnly(false)
                self?.favoritesListView.setEditing(false)
                self?.resetHeader()
                self?.setTitle("Veldig langt navn, ganske nøyaktig 50 tegn faktisk")
            },
            TweakingOption(title: "Empty folder", description: "A folder with no favorites") { [weak self] in
                self?.setReadOnly(false)
                self?.setViewModels([])
                self?.favoritesListView.setEditing(false)
                self?.resetHeader()
            },
            TweakingOption(title: "Edit mode", description: "None selected") { [weak self] in
                self?.resetViewModels()
                self?.setReadOnly(false)
                self?.favoritesListView.setEditing(true)
                self?.favoritesListView.selectAllRows(false, animated: false)
                self?.resetHeader()
            },
            TweakingOption(title: "Edit mode", description: "All selected") { [weak self] in
                self?.resetViewModels()
                self?.setReadOnly(false)
                self?.favoritesListView.setEditing(true)
                self?.favoritesListView.selectAllRows(true, animated: false)
                self?.resetHeader()
            },
            TweakingOption(title: "Shared folder", description: "Personal shared folder") { [weak self] in
                self?.resetViewModels()
                self?.setReadOnly(false)
                self?.favoritesListView.setEditing(false)
                self?.resetHeader()
                self?.favoritesListView.isShared = true
            },
            TweakingOption(title: "Read-only folder", description: "Default models") { [weak self] in
                self?.resetViewModels()
                self?.setReadOnly(true)
                self?.favoritesListView.setEditing(false)
                self?.resetHeader()
            },
            TweakingOption(title: "Read-only folder", description: "No favorites") { [weak self] in
                self?.setViewModels([])
                self?.setReadOnly(true)
                self?.favoritesListView.setEditing(false)
                self?.resetHeader()
            }
        ]
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.addSubview(favoritesListView)
        favoritesListView.fillInSuperview()

        navigationItem.titleView = navigationTitleView
        resetViewModels()
        resetHeader()
    }

    private func setReadOnly(_ isReadOnly: Bool) {
        guard favoritesListView.isReadOnly != isReadOnly else {
            return
        }

        favoritesListView.isReadOnly = isReadOnly
        favoritesListView.isSearchBarHidden = isReadOnly
    }

    private func resetHeader() {
        favoritesListView.isShared = false
        setTitle(folderTitle)
    }

    private func setTitle(_ title: String) {
        favoritesListView.title = title
        navigationTitleView.title = title
    }

    private func resetViewModels() {
        setViewModels(viewModels)
    }

    private func setViewModels(_ viewModels: [FavoriteAdViewModel]) {
        favoritesListView.setListIsEmpty(viewModels.isEmpty)
        favoritesListView.subtitle = "\(viewModels.count) favoritter"
        sectionDataSource.configureSection(forAds: viewModels, withSort: currentSorting, filterQuery: favoritesListView.searchBarText)
        favoritesListView.reloadData()
    }
}

// MARK: - FavoriteAdsListViewDelegate

extension FavoriteAdsListDemoViewController: FavoriteAdsListViewDelegate {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath) {}
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButton button: UIButton, at indexPath: IndexPath) {}
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectShareButton button: UIButton) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectDeleteItemAt indexPath: IndexPath, sender: UIView) {
        print("Delete button selected")
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectCommentForItemAt indexPath: IndexPath, sender: UIView) {
        print("Comment button selected")
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectSortingView sortingView: UIView) {
        switch currentSorting {
        case .lastAdded:
            currentSorting = .alphabetically
        case .alphabetically:
            currentSorting = .lastAdded
        }
        view.sortingTitle = currentSorting.rawValue
        sectionDataSource.configureSection(forAds: viewModels, withSort: currentSorting, filterQuery: favoritesListView.searchBarText)
        view.reloadData()
    }

    func favoriteAdsListViewDidFocusSearchBar(_ view: FavoriteAdsListView) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didChangeSearchText searchText: String) {
        sectionDataSource.configureSection(forAds: viewModels, withSort: currentSorting, filterQuery: view.searchBarText)
        view.reloadData()
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, didUpdateTitleLabelVisibility isVisible: Bool) {
        navigationTitleView.setIsVisible(!isVisible)
    }
}

// MARK: - FavoriteAdsListViewDataSource

extension FavoriteAdsListDemoViewController: FavoriteAdsListViewDataSource {
    func favoriteAdsListView(_ view: FavoriteAdsListView, titleForHeaderInSection section: Int) -> String? {
        let section = sectionDataSource.sections[section]
        return section.sectionTitle
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, detailForHeaderInSection section: Int) -> String? {
        let section = sectionDataSource.sections[section]
        return section.sectionDetail
    }

    func numberOfSections(inFavoriteAdsListView view: FavoriteAdsListView) -> Int {
        return sectionDataSource.sections.count
    }

    func numberOfItems(inFavoriteAdsListView view: FavoriteAdsListView, forSection section: Int) -> Int {
        let section = sectionDataSource.sections[section]
        return section.ads.count
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, viewModelFor indexPath: IndexPath) -> FavoriteAdViewModel {
        let section = sectionDataSource.sections[indexPath.section]
        return section.ads[indexPath.row]
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView,
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

    func favoriteAdsListView(_ view: FavoriteAdsListView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - Private

extension FavoriteAdsListViewModel {
    static let `default` = FavoriteAdsListViewModel(
        searchBarPlaceholder: "Søk etter en av dine favoritter",
        shareButtonTitle: "Delt liste",
        addCommentActionTitle: "Skriv\nnotat",
        editCommentActionTitle: "Rediger\nnotat",
        deleteAdActionTitle: "Slett",
        emptySearchViewBodyPrefix: "Vi fant visst ingen favoritter for"
    )
}
