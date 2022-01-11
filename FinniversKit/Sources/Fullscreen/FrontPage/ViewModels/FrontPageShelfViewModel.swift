import Foundation

public class FrontPageShelfViewModel {
    private(set) var recentlyFavoritedItems: [RecentlyFavoritedViewmodel]
    private(set) var savedSearchItems: [SavedSearchShelfViewModel]
    private(set) var sectionTitles: [String]
    
    private let headerHeight: CGFloat = 44
    private let topPadding: CGFloat = 20
    private let savedSearchHeight: CGFloat = 90
    private let favoriteHeight: CGFloat = 190
    
    public var isFavoritedListEmpty: Bool {
        recentlyFavoritedItems.isEmpty
    }
    
    public var heightForShelf: CGFloat {
        return 0 + (!savedSearchItems.isEmpty ? (savedSearchSectionHeight) : 0) +
        (!recentlyFavoritedItems.isEmpty ? (recentlyFavoritedSectionHeight) : 0)
    }
    
    public var savedSearchSectionHeight: CGFloat {
        headerHeight + topPadding + savedSearchHeight
    }
    
    public var recentlyFavoritedSectionHeight: CGFloat {
        headerHeight + topPadding + favoriteHeight
    }
    
    public init(favoritedItems: [RecentlyFavoritedViewmodel], savedSearchItems: [SavedSearchShelfViewModel], sectionTitles: [String]) {
        self.recentlyFavoritedItems = favoritedItems
        self.savedSearchItems = savedSearchItems
        self.sectionTitles = sectionTitles
    }
    
    public func replaceFavoriteItems(withItems items: [RecentlyFavoritedViewmodel]) {
        self.recentlyFavoritedItems = items
    }
    
    public func replaceSavedSearchItems(withItems items: [SavedSearchShelfViewModel]) {
        self.savedSearchItems = items
    }
    
    public func removeFavoritedItem(atIndex index: Int) {
        recentlyFavoritedItems.remove(at: index)
    }
    
    public func removeFavoritedItem(_ item: RecentlyFavoritedViewmodel) {
        guard let index = recentlyFavoritedItems.firstIndex(of: item) else { return }
        removeFavoritedItem(atIndex: index)
    }
    
    public func titleForSection(at index: Int) -> String {
        guard index < sectionTitles.count else { return "" }
        return sectionTitles[index]
    }
}
