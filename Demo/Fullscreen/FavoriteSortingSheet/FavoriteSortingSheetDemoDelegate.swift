//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteSortingSheetDemoDelegate: FavoriteSortingSheetDelegate {
    static let shared = FavoriteSortingSheetDemoDelegate()

    func favoriteSortingSheet(_ sortingSheet: FavoriteSortingSheet, didSelectSortOption option: FavoriteSortOption) {
        print("\(option) selected")
    }
}
