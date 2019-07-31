//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteFoldersListViewModel {
    public let searchBarPlaceholder: String
    public let addFolderText: String
    public let emptyViewBodyPrefix: String
    public let addBottomSafeAreaInset: Bool

    // MARK: - Init

    public init(
        searchBarPlaceholder: String,
        addFolderText: String,
        emptyViewBodyPrefix: String,
        addBottomSafeAreaInset: Bool = true
    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.addFolderText = addFolderText
        self.emptyViewBodyPrefix = emptyViewBodyPrefix
        self.addBottomSafeAreaInset = addBottomSafeAreaInset
    }
}
