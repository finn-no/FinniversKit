//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteFoldersListViewModel {
    public let searchBarPlaceholder: String
    public let addFolderText: String
    public let emptyViewBodyPrefix: String
    public let isEditable: Bool
    public let addBottomSafeAreaInset: Bool

    /// Title for the trailing "rename" swipe action. When `nil` the action is
    /// omitted from the swipe row (backwards-compatible with hosts that only
    /// support delete).
    public let renameActionTitle: String?

    /// Title for the trailing "share" swipe action. When `nil` the action is
    /// omitted from the swipe row.
    public let shareActionTitle: String?

    /// Title for the trailing "delete" swipe action. Falls back to the system
    /// default when `nil`.
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
