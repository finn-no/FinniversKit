//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteFoldersListViewModel {
    public let searchBarPlaceholder: String
    public let addFolderText: String
    public let cancelButtonTitle: String

    // MARK: - Init

    public init(searchBarPlaceholder: String, addFolderText: String, cancelButtonTitle: String) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.addFolderText = addFolderText
        self.cancelButtonTitle = cancelButtonTitle
    }
}
