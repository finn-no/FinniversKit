//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FavoriteFolderActionViewModel {
    public let editText: String
    public let changeNameText: String
    public let shareText: String
    public let copyLinkButtonTitle: String
    public let copyLinkButtonDescription: String
    public let deleteText: String

    public init(
        editText: String,
        changeNameText: String,
        shareText: String,
        copyLinkButtonTitle: String,
        copyLinkButtonDescription: String,
        deleteText: String
    ) {
        self.editText = editText
        self.changeNameText = changeNameText
        self.shareText = shareText
        self.copyLinkButtonTitle = copyLinkButtonTitle
        self.copyLinkButtonDescription = copyLinkButtonDescription
        self.deleteText = deleteText
    }
}
