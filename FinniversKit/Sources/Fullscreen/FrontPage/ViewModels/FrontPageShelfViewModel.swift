import Foundation

public class FrontPageShelfViewModel {
    private(set) var recentlyFavoritedItems: [RecentlyFavoritedViewmodel]
    private(set) var savedSearchItems: [SavedSearchShelfViewModel]
    private(set) var sectionTitles: [String]
    
    private let headerHeight: CGFloat = 44
    private let topPadding: CGFloat = 20
    private let savedSearchHeight: CGFloat = 90
    private let favoriteHeight: CGFloat = 190
    
    var isFavoritedListEmpty: Bool {
        recentlyFavoritedItems.isEmpty
    }
    
    
    var heightForShelf: CGFloat {
        return 0 + (!savedSearchItems.isEmpty ? (savedSearchSectionHeight) : 0) +
        (!recentlyFavoritedItems.isEmpty ? (recentlyFavoritedSectionHeight) : 0)
    }
    
    var savedSearchSectionHeight: CGFloat {
        headerHeight + topPadding + savedSearchHeight
    }
    
    var recentlyFavoritedSectionHeight: CGFloat {
        headerHeight + topPadding + favoriteHeight
    }
    
    public init(favoritedItems: [RecentlyFavoritedViewmodel], savedSearchItems: [SavedSearchShelfViewModel], sectionTitles: [String]) {
        self.recentlyFavoritedItems = favoritedItems
        self.savedSearchItems = savedSearchItems
        self.sectionTitles = sectionTitles
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
}
