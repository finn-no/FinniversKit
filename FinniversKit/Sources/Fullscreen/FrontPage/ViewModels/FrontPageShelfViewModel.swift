import Foundation

public class FrontPageShelfViewModel {
    private(set) var recentlyFavoritedItems: [RecentlyFavoritedViewmodel]
    private(set) var savedSearchItems: [SavedSearchShelfViewModel]
    private(set) var sectionTitles: [String]
    private (set) var buttonTitles: [String]

    var heightForShelf: CGFloat {
        savedSearchSectionHeight + sectionSpacing + recentlyFavoritedSectionHeight
    }

    private var savedSearchSectionHeight: CGFloat {
        guard !savedSearchItems.isEmpty else { return 0 }
        return FrontPageShelfView.headerHeight + FrontPageShelfView.savedSearchCellHeight
    }

    private var sectionSpacing: CGFloat {
        if !savedSearchItems.isEmpty && !recentlyFavoritedItems.isEmpty {
            return FrontPageShelfView.sectionSpacing
        }
        return 0
    }

    private var recentlyFavoritedSectionHeight: CGFloat {
        guard !recentlyFavoritedItems.isEmpty else { return 0 }
        return FrontPageShelfView.headerHeight + FrontPageShelfView.favoriteCellHeight
    }

    public init(favoritedItems: [RecentlyFavoritedViewmodel], savedSearchItems: [SavedSearchShelfViewModel], sectionTitles: [String], buttonTitles: [String]) {
        self.recentlyFavoritedItems = favoritedItems
        self.savedSearchItems = savedSearchItems
        self.sectionTitles = sectionTitles
        self.buttonTitles = buttonTitles
    }
    
    func removeFavoritedItem(atIndex index: Int) {
        recentlyFavoritedItems.remove(at: index)
    }
    
    func removeFavoritedItem(_ item: RecentlyFavoritedViewmodel) {
        guard let index = recentlyFavoritedItems.firstIndex(of: item) else { return }
        removeFavoritedItem(atIndex: index)
    }
    
    func titleForSection(at index: Int) -> String {
        guard index < sectionTitles.count else { return "" }
        return sectionTitles[index]
    }
    
    func titleForButton(at index: Int) -> String {
        guard index < buttonTitles.count else { return "" }
        return buttonTitles[index]
    }
}
