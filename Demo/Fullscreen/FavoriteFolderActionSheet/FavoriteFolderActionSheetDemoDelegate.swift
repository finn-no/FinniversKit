//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFolderActionSheetDemoDelegate: FavoriteFolderActionSheetDelegate {
    static let shared = FavoriteFolderActionSheetDemoDelegate()

    func favoriteFolderActionSheet(_ actionSheet: FavoriteFolderActionSheet, didSelectAction action: FavoriteFolderAction) {
        print("\(action) selected")

        switch action {
        case .share:
            actionSheet.isCopyLinkHidden.toggle()
        default:
            break
        }
    }
}
