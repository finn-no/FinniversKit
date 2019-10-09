//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum RecyclingDemoViews: String, CaseIterable {
    case basic
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
        case .basic:
            return DemoViewController<BasicTableViewDemoView>()
        case .notificationsListView:
            return DemoViewController<NotificationsListViewDemoView>()
        case .favoriteFoldersListView:
            let viewController = DemoViewController<FavoriteFoldersListDemoView>(constrainToBottomSafeArea: false)
            viewController.title = "Favoritter"

            let navigationController = NavigationController(rootViewController: viewController)
            navigationController.navigationBar.barTintColor = .bgPrimary
            navigationController.navigationBar.shadowImage = UIImage()

            return navigationController
        case .favoriteAdSortingView:
            return DemoViewController<FavoriteAdSortingDemoView>()
        case .favoriteAdActionView:
            return DemoViewController<FavoriteAdActionDemoView>()
        case .favoritesListView:
            return DemoViewController<FavoritesListViewDemoView>()
        case .savedSearchesListView:
            return DemoViewController<SavedSearchesListViewDemoView>()
        case .marketsGridView:
            return DemoViewController<MarketsGridViewDemoView>()
        case .adsGridView:
            return DemoViewController<AdsGridViewDemoView>()
        case .settingsView:
            return DemoViewController<SettingsViewDemoView>()
        case .userAds:
            return DemoViewController<UserAdsListViewDemoView>()
        case .adManagementView:
            return DemoViewController<AdManagementDemoView>()
        case .neighborhoodProfileView:
            return DemoViewController<NeighborhoodProfileDemoView>()
        }
    }
}
