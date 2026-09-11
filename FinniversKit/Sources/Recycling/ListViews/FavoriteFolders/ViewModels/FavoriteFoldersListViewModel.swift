//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteFoldersListViewModel {
    public let searchBarPlaceholder: String
    public let addFolderText: String
    public let emptyViewBodyPrefix: String
    public let isEditable: Bool
    public let addBottomSafeAreaInset: Bool

    public let renameActionTitle: String?
    public let shareActionTitle: String?
    public let deleteActionTitle: String?

    // MARK: - Init

    public init(
        searchBarPlaceholder: String,
        addFolderText: String,
        emptyViewBodyPrefix: String,
        isEditable: Bool,
        addBottomSafeAreaInset: Bool = true,
        renameActionTitle: String? = nil,
        shareActionTitle: String? = nil,
        deleteActionTitle: String? = nil
    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.addFolderText = addFolderText
        self.emptyViewBodyPrefix = emptyViewBodyPrefix
        self.isEditable = isEditable
        self.addBottomSafeAreaInset = addBottomSafeAreaInset
        self.renameActionTitle = renameActionTitle
        self.shareActionTitle = shareActionTitle
        self.deleteActionTitle = deleteActionTitle
    }
}
