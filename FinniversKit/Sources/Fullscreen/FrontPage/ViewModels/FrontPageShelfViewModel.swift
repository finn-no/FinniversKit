import Foundation

public class FrontPageShelfViewModel {
    private(set) var savedSearchItems: [SavedSearchShelfViewModel]
    let title: String
    let buttonTitle: String

    var heightForShelf: CGFloat {
        savedSearchSectionHeight
    }

    private var savedSearchSectionHeight: CGFloat {
        guard !savedSearchItems.isEmpty else { return 0 }
        return FrontPageSavedSearchView.headerHeight + FrontPageSavedSearchView.savedSearchCellHeight
    }

    public init(savedSearchItems: [SavedSearchShelfViewModel], title: String, buttonTitle: String) {
        self.savedSearchItems = savedSearchItems
        self.title = title
        self.buttonTitle = buttonTitle
    }
}
