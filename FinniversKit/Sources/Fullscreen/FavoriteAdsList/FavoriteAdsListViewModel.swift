//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FavoriteAdsListViewModel {
    public let searchBarPlaceholder: String
    public let headerShareButtonTitle: String
    public let footerShareButtonTitle: String
    public let addCommentActionTitle: String
    public let editCommentActionTitle: String
    public let deleteAdActionTitle: String
    public let emptySearchViewBodyPrefix: String
    public let emptyListViewTitle: String
    public let emptyListViewBody: String
    public let emptyListViewImage: UIImage
    public var panelTextToriOnboarding: String
    public var showPanelForToriOnboarding: Bool

    public init(
        searchBarPlaceholder: String,
        headerShareButtonTitle: String,
        footerShareButtonTitle: String,
        addCommentActionTitle: String,
        editCommentActionTitle: String,
        deleteAdActionTitle: String,
        emptySearchViewBodyPrefix: String,
        emptyListViewTitle: String,
        emptyListViewBody: String,
        emptyListViewImage: UIImage,
        panelTextToriOnboarding: String,
        showPanelForToriOnboarding: Bool

    ) {
        self.searchBarPlaceholder = searchBarPlaceholder
        self.headerShareButtonTitle = headerShareButtonTitle
        self.footerShareButtonTitle = footerShareButtonTitle
        self.addCommentActionTitle = addCommentActionTitle
        self.editCommentActionTitle = editCommentActionTitle
        self.deleteAdActionTitle = deleteAdActionTitle
        self.emptySearchViewBodyPrefix = emptySearchViewBodyPrefix
        self.emptyListViewTitle = emptyListViewTitle
        self.emptyListViewBody = emptyListViewBody
        self.emptyListViewImage = emptyListViewImage
        self.panelTextToriOnboarding = panelTextToriOnboarding
        self.showPanelForToriOnboarding = showPanelForToriOnboarding
    }
}
