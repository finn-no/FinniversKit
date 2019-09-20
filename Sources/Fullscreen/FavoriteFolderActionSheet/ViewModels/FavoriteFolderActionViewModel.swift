//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FavoriteFolderActionViewModel {
    public enum Appearance {
        case full
        case minimal
    }

    public let appearance: Appearance
    public let editText: String
    public let renameText: String
    public let shareToggleText: String
    public let shareLinkButtonTitle: String
    public let shareLinkButtonDescription: String
    public let deleteText: String

    public init(
        appearance: Appearance = .minimal,
        editText: String,
        renameText: String,
        shareToggleText: String,
        shareLinkButtonTitle: String,
        shareLinkButtonDescription: String,
        deleteText: String
    ) {
        self.appearance = appearance
        self.editText = editText
        self.renameText = renameText
        self.shareToggleText = shareToggleText
        self.shareLinkButtonTitle = shareLinkButtonTitle
        self.shareLinkButtonDescription = shareLinkButtonDescription
        self.deleteText = deleteText
    }
}
