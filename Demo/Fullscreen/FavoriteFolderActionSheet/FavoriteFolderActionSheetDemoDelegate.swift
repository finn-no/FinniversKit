//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFolderActionSheetDemoDelegate: FavoriteFolderActionSheetDelegate {
    static let shared = FavoriteFolderActionSheetDemoDelegate()

    func favoriteFolderActionSheet(_ actionSheet: FavoriteFolderActionSheet, didSelectAction action: FavoriteFolderAction) {
        print("\(action) selected")

        switch action {
        case .toggleSharing:
            actionSheet.isShared.toggle()
        default:
            break
        }
    }
}
