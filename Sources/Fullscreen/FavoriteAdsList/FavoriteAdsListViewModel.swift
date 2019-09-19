//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteAdsListViewModel {
    public let searchBarPlaceholder: String
    public let addCommentActionTitle: String
    public let editCommentActionTitle: String
    public let deleteAdActionTitle: String

    public init(
        searchBarPlaceholder: String,
        addCommentActionTitle: String,
        editCommentActionTitle: String,
        deleteAdActionTitle: String
    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.addCommentActionTitle = addCommentActionTitle
        self.editCommentActionTitle = editCommentActionTitle
        self.deleteAdActionTitle = deleteAdActionTitle
    }
}
