//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdSortingSheetDemoDelegate: FavoriteAdSortingSheetDelegate {
    static let shared = FavoriteAdSortingSheetDemoDelegate()

    func favoriteAdSortingSheet(_ sortingSheet: FavoriteAdSortingSheet, didSelectSortOption option: FavoriteAdSortOption) {
        print("\(option) selected")
    }
}
