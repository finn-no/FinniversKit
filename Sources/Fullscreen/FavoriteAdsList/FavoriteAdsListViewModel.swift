//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteAdsListViewModel {
    public let searchBarPlaceholder: String
    public let shareButtonTitle: String
    public let addCommentActionTitle: String
    public let editCommentActionTitle: String
    public let deleteAdActionTitle: String
    public let emptySearchViewBodyPrefix: String

    public init(
        searchBarPlaceholder: String,
        shareButtonTitle: String,
        addCommentActionTitle: String,
        editCommentActionTitle: String,
        deleteAdActionTitle: String,
        emptySearchViewBodyPrefix: String
    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.shareButtonTitle = shareButtonTitle
        self.addCommentActionTitle = addCommentActionTitle
        self.editCommentActionTitle = editCommentActionTitle
        self.deleteAdActionTitle = deleteAdActionTitle
        self.emptySearchViewBodyPrefix = emptySearchViewBodyPrefix
    }
}
