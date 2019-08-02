//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

enum AdsSorting: String {
    case lastAdded = "Sist lagt til"
    case alphabetically = "Alfabetisk"
}

class FavoriteAdsListDemoView: UIView {
    private let viewModels = FavoriteAdsFactory.create()
    private let sectionDataSource = FavoriteAdsDemoDataSource()
    private var currentSorting: AdsSorting = .lastAdded

    private lazy var favoritesListView: FavoriteAdsListView = {
        let view = FavoriteAdsListView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        view.title = "Mine funn"
        view.subtitle = "\(viewModels.count) favoritter"
        view.searchBarPlaceholder = "Søk etter en av dine favoritter"
        view.sortingTitle = currentSorting.rawValue
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        sectionDataSource.section(ads: viewModels, withSort: currentSorting, filterQuery: favoritesListView.searchBarText)
        addSubview(favoritesListView)
        favoritesListView.fillInSuperview()
    }
}

// MARK: - FavoriteAdsListViewDelegate

extension FavoriteAdsListDemoView: FavoriteAdsListViewDelegate {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButtonForItemAt indexPath: IndexPath) {}

    func favoriteAdsListViewDidSelectSortButton(_ view: FavoriteAdsListView) {
        switch currentSorting {
        case .lastAdded:
            currentSorting = .alphabetically
        case .alphabetically:
            currentSorting = .lastAdded
        }
        view.sortingTitle = currentSorting.rawValue
        sectionDataSource.section(ads: viewModels, withSort: currentSorting, filterQuery: favoritesListView.searchBarText)
        view.reloadData()
    }

    func favoriteAdsListViewDidFocusSearchBar(_ view: FavoriteAdsListView) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didChangeSearchText searchText: String) {
        sectionDataSource.section(ads: viewModels, withSort: currentSorting, filterQuery: view.searchBarText)
        view.reloadData()
    }
}

// MARK: - FavoriteAdsListViewDataSource

extension FavoriteAdsListDemoView: FavoriteAdsListViewDataSource {
    func favoriteAdsListView(_ view: FavoriteAdsListView, titleForHeaderInSection section: Int) -> String? {
        let section = sectionDataSource.sections[section]
        return section.sectionTitle
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
