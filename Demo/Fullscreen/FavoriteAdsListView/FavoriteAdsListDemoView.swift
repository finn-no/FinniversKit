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
        view.sortingTitle = "Sist lagt til"
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        sectionDataSource.sort(ads: viewModels, by: currentSorting)
        addSubview(favoritesListView)
        favoritesListView.fillInSuperview()
    }
}

// MARK: - FavoriteAdsListViewDelegate

extension FavoriteAdsListDemoView: FavoriteAdsListViewDelegate {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAtIndex index: Int) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButtonForItemAtIndex index: Int) {}

    func favoriteAdsListViewDidSelectSortButton(_ view: FavoriteAdsListView) {
        switch currentSorting {
        case .lastAdded:
            currentSorting = .alphabetically
        case .alphabetically:
            currentSorting = .lastAdded
        }
        view.sortingTitle = currentSorting.rawValue
        sectionDataSource.sort(ads: viewModels, by: currentSorting)
    }

    func favoriteAdsListViewDidFocusSearchBar(_ view: FavoriteAdsListView) {}

    func favoriteAdsListView(_ view: FavoriteAdsListView, didChangeSearchText searchText: String) {}
}

// MARK: - FavoriteAdsListViewDataSource

extension FavoriteAdsListDemoView: FavoriteAdsListViewDataSource {
    func numberOfItems(inFavoriteAdsListView view: FavoriteAdsListView) -> Int {
        return viewModels.count
    }

    func favoriteAdsListView(_ view: FavoriteAdsListView, viewModelAtIndex index: Int) -> FavoriteAdViewModel {
        return viewModels[index]
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
