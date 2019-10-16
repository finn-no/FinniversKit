//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum RecyclingDemoViews: String, CaseIterable {
    case basicTableView
    case notificationsListView
    case favoriteFoldersListView
    case favoriteAdSortingView
    case favoriteAdActionView
    case favoritesListView
    case savedSearchesListView
    case marketsGridView
    case adsGridView
    case settingsView
    case userAds
    case adManagementView
    case neighborhoodProfileView

    public static var items: [RecyclingDemoViews] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }

    public var viewController: UIViewController {
        switch self {
        case .basicTableView:
            return DemoViewController<BasicTableViewDemoView>()
        case .notificationsListView:
            return DemoViewControllerContainer<NotificationsListViewDemoView>()
        case .favoriteFoldersListView:
            let viewController = DemoViewController<FavoriteFoldersListDemoView>(constrainToBottomSafeArea: false)
            viewController.title = "Favoritter"

            let navigationController = NavigationController(rootViewController: viewController)
            navigationController.navigationBar.barTintColor = .bgPrimary
            navigationController.navigationBar.shadowImage = UIImage()

            return navigationController
        case .favoriteAdSortingView:
            return DemoViewControllerContainer<FavoriteAdSortingDemoView>()
        case .favoriteAdActionView:
            return DemoViewControllerContainer<FavoriteAdActionDemoView>()
        case .favoritesListView:
            return DemoViewControllerContainer<FavoritesListViewDemoView>()
        case .savedSearchesListView:
            return DemoViewControllerContainer<SavedSearchesListViewDemoView>()
        case .marketsGridView:
            return DemoViewControllerContainer<MarketsGridViewDemoView>()
        case .adsGridView:
            return DemoViewControllerContainer<AdsGridViewDemoView>()
        case .settingsView:
            return DemoViewControllerContainer<SettingsViewDemoView>()
        case .userAds:
            return DemoViewControllerContainer<UserAdsListViewDemoView>()
        case .adManagementView:
            return DemoViewControllerContainer<AdManagementDemoView>()
        case .neighborhoodProfileView:
            return DemoViewControllerContainer<NeighborhoodProfileDemoView>()
        }
    }
}
