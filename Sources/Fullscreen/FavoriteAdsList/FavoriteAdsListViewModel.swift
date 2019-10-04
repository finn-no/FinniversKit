//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteAdsListViewModel {
    public let searchBarPlaceholder: String
    public let addCommentActionTitle: String
    public let editCommentActionTitle: String
    public let deleteAdActionTitle: String
    public let emptySearchViewBodyPrefix: String
    public let emptyListViewTitle: String
    public let emptyListViewBody: String
    public let emptyListViewImage: UIImage

    public init(
        searchBarPlaceholder: String,
        addCommentActionTitle: String,
        editCommentActionTitle: String,
        deleteAdActionTitle: String,
        emptySearchViewBodyPrefix: String,
        emptyListViewTitle: String,
        emptyListViewBody: String,
        emptyListViewImage: UIImage
    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.addCommentActionTitle = addCommentActionTitle
        self.editCommentActionTitle = editCommentActionTitle
        self.deleteAdActionTitle = deleteAdActionTitle
        self.emptySearchViewBodyPrefix = emptySearchViewBodyPrefix
        self.emptyListViewTitle = emptyListViewTitle
        self.emptyListViewBody = emptyListViewBody
        self.emptyListViewImage = emptyListViewImage
    }
}
