//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteActionsListDemoDelegate: FavoriteActionsBottomSheetDelegate {
    static let shared = FavoriteActionsListDemoDelegate()

    func favoriteActionsBottomSheet(_ bottomSheet: FavoriteActionsBottomSheet, didSelectAction action: FavoriteActionsListView.Action) {
        print("\(action) selected")

        switch action {
        case .share:
            bottomSheet.isShared.toggle()
        default:
            break
        }
    }
}
