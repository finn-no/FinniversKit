//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import DemoKit

enum RecyclingDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case basicTableView
    case notificationsListView
    case favoriteFoldersListView
    case favoritesListView
    case savedSearchesListView
    case marketsGridView
    case compactMarketsView
    case adRecommendationsGridView
    case settingsView
    case adManagementView
    case neighborhoodProfileView

    static var groupTitle: String { "Recycling" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .basicTableView:
            return BasicTableViewDemoView()
        case .notificationsListView:
            return NotificationsListViewDemoView()
        case .favoriteFoldersListView:
            return FavoriteFoldersListDemoView()
        case .favoritesListView:
            return FavoritesListViewDemoView()
        case .savedSearchesListView:
            return SavedSearchesListViewDemoView()
        case .marketsGridView:
            return MarketsDemoView()
        case .compactMarketsView:
            return CompactMarketsDemoView()
        case .adRecommendationsGridView:
            return AdRecommendationsGridViewDemoView()
        case .settingsView:
            return SettingsViewDemoView()
        case .adManagementView:
            return AdManagementDemoView()
        case .neighborhoodProfileView:
            return NeighborhoodProfileDemoView()
        }
    }
}
