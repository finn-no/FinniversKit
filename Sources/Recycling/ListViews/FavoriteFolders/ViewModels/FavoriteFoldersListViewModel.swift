//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteFoldersListViewModel {
    public let searchBarPlaceholder: String
    public let addFolderText: String
    public let emptyViewBodyPrefix: String
    public let useSafeAreaInsets: Bool

    // MARK: - Init

    public init(
        searchBarPlaceholder: String,
        addFolderText: String,
        emptyViewBodyPrefix: String,
        useSafeAreaInsets: Bool = true
    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.addFolderText = addFolderText
        self.emptyViewBodyPrefix = emptyViewBodyPrefix
        self.useSafeAreaInsets = useSafeAreaInsets
    }
}
