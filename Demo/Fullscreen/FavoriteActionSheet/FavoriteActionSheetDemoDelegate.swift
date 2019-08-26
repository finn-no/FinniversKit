//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteActionSheetDemoDelegate: FavoriteActionSheetDelegate {
    static let shared = FavoriteActionSheetDemoDelegate()

    func favoriteActionSheet(_ actionSheet: FavoriteActionSheet, didSelectAction action: FavoriteAction) {
        print("\(action) selected")
    }
}
