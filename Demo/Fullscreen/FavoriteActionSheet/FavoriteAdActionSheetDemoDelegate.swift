//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdActionSheetDemoDelegate: FavoriteAdActionSheetDelegate {
    static let shared = FavoriteAdActionSheetDemoDelegate()

    func favoriteAdActionSheet(_ actionSheet: FavoriteAdActionSheet, didSelectAction action: FavoriteAdAction) {
        print("\(action) selected")
    }
}
