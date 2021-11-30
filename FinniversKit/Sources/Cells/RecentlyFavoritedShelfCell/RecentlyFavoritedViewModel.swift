import Foundation

public struct RecentlyFavoritedViewmodel: Hashable{
    public let id: Int
    public let imageUrl: String?
    public let location: String?
    public let title: String?
    public let created: String
    public let price: String?
    private let identifier = UUID()
    
    public init(id: Int, imageUrl: String?, location: String?, title: String?, created: String, price: String?) {
        self.id = id
        self.imageUrl = imageUrl
        self.location = location
        self.title = title
        self.created = created
        self.price = price
    }
    
    public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
    }
}
