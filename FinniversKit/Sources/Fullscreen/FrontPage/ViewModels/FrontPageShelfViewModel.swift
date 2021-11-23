import Foundation

public class FrontPageShelfViewModel {
    private(set) var recentlyFavoritedItems: [RecentlyFavoritedViewmodel]
    private(set) var savedSearchItems: [SavedSearchShelfViewModel]
    
    private let headerHeight: CGFloat = 44
    private let topPadding: CGFloat = 20
    private let savedSearchHeight: CGFloat = 90
    private let favoriteHeight: CGFloat = 190
    
    public var heightForShelf: CGFloat {
        return 0 + (!savedSearchItems.isEmpty ? (headerHeight + topPadding + savedSearchHeight) : 0) +
        (!recentlyFavoritedItems.isEmpty ? (headerHeight + topPadding + favoriteHeight) : 0)
    }
    
    public init(favoritedItems: [RecentlyFavoritedViewmodel], savedSearchItems: [SavedSearchShelfViewModel]) {
        self.recentlyFavoritedItems = favoritedItems
        self.savedSearchItems = savedSearchItems
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
}
