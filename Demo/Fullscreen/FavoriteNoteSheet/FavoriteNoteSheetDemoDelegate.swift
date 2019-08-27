//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteNoteSheetDemoDelegate: FavoriteNoteSheetDelegate {
    static let shared = FavoriteNoteSheetDemoDelegate()

    func favoriteNoteSheetDidSelectCancel(_ sheet: FavoriteNoteSheet) {
        sheet.state = .dismissed
    }

    func favoriteNoteSheet(_ sheet: FavoriteNoteSheet, didSelectSaveWithText text: String?) {
        sheet.state = .dismissed
    }
}
