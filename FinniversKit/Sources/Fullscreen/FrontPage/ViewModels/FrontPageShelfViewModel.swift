import Foundation

public class FrontPageShelfViewModel {
    private(set) var savedSearchItems: [SavedSearchShelfViewModel]
    let storiesTitle: String
    let buttonTitle: String

    var heightForShelf: CGFloat {
        savedSearchSectionHeight
    }

    private var savedSearchSectionHeight: CGFloat {
        guard !savedSearchItems.isEmpty else { return 0 }
        return FrontPageShelfView.headerHeight + FrontPageShelfView.savedSearchCellHeight
    }

    public init(savedSearchItems: [SavedSearchShelfViewModel], storiesTitle: String, buttonTitle: String) {
        self.savedSearchItems = savedSearchItems
        self.storiesTitle = storiesTitle
        self.buttonTitle = buttonTitle
    }
}
