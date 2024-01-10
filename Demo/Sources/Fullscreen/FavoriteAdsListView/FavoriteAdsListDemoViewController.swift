//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

enum AdsSorting: String {
    case lastAdded = "Sist lagt til"
    case alphabetically = "Alfabetisk"
}

class FavoriteAdsListDemoView: UIView {

    // MARK: - Private properties

    private let viewModels = FavoriteAdsFactory.create()
    private let sectionDataSource = FavoriteAdsDemoDataSource()
    private var currentSorting: AdsSorting = .lastAdded
    private var folderTitle = "Mine funn"

    private lazy var favoritesListView: FavoriteAdsListView = {
        let view = FavoriteAdsListView(viewModel: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.title = folderTitle
        view.subtitle = "\(viewModels.count) favoritter"
        view.sortingTitle = currentSorting.rawValue
        view.isFooterShareButtonHidden = true
        view.configure(scrollShadowHeight: 44)
        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Private

    private func setup() {
        addSubview(favoritesListView)
        favoritesListView.fillInSuperview()
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
    }

    private func resetViewModels() {
        setViewModels(viewModels)
    }

    private func setViewModels(_ viewModels: [FavoriteAdViewModel]) {
        favoritesListView.setListIsEmpty(viewModels.isEmpty)
        favoritesListView.subtitle = "\(viewModels.count) favoritter"
        sectionDataSource.configureSection(forAds: viewModels, withSort: currentSorting, filterQuery: favoritesListView.searchBarText)
        favoritesListView.reloadData(scrollToTop: true)
    }
}

extension FavoriteAdsListDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case selectionMode
        case selectionModeWithMessages
        case selectionModeWithLongTitle
        case emptyFolder
        case editModeNoneSelected
        case editModeAllSelected
        case sharedPersonalFolder
        case readOnlyFolderDefaultModels
        case readOnlyFolderNoFavorites
        case footerShareButton
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        favoritesListView.configure(infoMessages: [])

        switch Tweaks.allCases[index] {
        case .selectionMode:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
        case .selectionModeWithMessages:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
            favoritesListView.configure(infoMessages: [
                .message(
                    "This is a single demo message. It's kinda long, but it should still present as needed",
                    backgroundColor: .aqua50
                ),
                .infobox(
                    title: "Important message",
                    message: "There is an important message we want to inform you about. That message will appear here.",
                    style: .warning
                )
            ])
        case .selectionModeWithLongTitle:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(false)
            resetHeader()
            setTitle("Veldig langt navn, ganske nøyaktig 50 tegn faktisk")
            favoritesListView.isFooterShareButtonHidden = true
        case .emptyFolder:
            setReadOnly(false)
            setViewModels([])
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
        case .editModeNoneSelected:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(true)
            favoritesListView.selectAllRows(false, animated: false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
        case .editModeAllSelected:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(true)
            favoritesListView.selectAllRows(true, animated: false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
        case .sharedPersonalFolder:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isShared = true
            favoritesListView.isFooterShareButtonHidden = true
        case .readOnlyFolderDefaultModels:
            resetViewModels()
            setReadOnly(true)
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
        case .readOnlyFolderNoFavorites:
            setViewModels([])
            setReadOnly(true)
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = true
        case .footerShareButton:
            resetViewModels()
            setReadOnly(false)
            favoritesListView.setEditing(false)
            resetHeader()
            favoritesListView.isFooterShareButtonHidden = false
        }
    }
}

// MARK: - FavoriteAdsListViewDelegate

extension FavoriteAdsListDemoView: FavoriteAdsListViewDelegate {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath) {}
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButton button: UIButton, at indexPath: IndexPath) {}
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectHeaderShareButton button: UIButton) {}
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectFooterShareButton button: UIButton) {}

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
        view.reloadData(scrollToTop: true)
    }

    func favoriteAdsListViewDidFocusSearchBar(_ view: FavoriteAdsListView) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didChangeSearchText searchText: String) {
        sectionDataSource.configureSection(forAds: viewModels, withSort: currentSorting, filterQuery: view.searchBarText)
        view.reloadData(scrollToTop: true)
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, didUpdateTitleLabelVisibility isVisible: Bool) {}
}

// MARK: - FavoriteAdsListViewDataSource

extension FavoriteAdsListDemoView: FavoriteAdsListViewDataSource {
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
        headerShareButtonTitle: "Delt liste",
        footerShareButtonTitle: "Del ønskelisten din",
        addCommentActionTitle: "Skriv\nnotat",
        editCommentActionTitle: "Rediger\nnotat",
        deleteAdActionTitle: "Slett",
        emptySearchViewBodyPrefix: "Vi fant visst ingen favoritter for",
        emptyListViewTitle: "Her var det stille gitt...",
        emptyListViewBody: "Det er ikke lagt til noen favoritter i denne listen enda.",
        emptyListViewImage: UIImage(named: .heartEmpty)
    )
}
