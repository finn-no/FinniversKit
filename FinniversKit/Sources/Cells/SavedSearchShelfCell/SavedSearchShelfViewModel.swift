import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: Int
    public let adId: Int
    public let created: Date
    
    public init(id: Int = Int.random(in: 0...100_000), title: String, imageUrlString: String?, adId: Int = Int.random(in: 0...100_000), created: Date = Date()) {
        self.title = title
        self.imageUrlString = imageUrlString
        self.id = id
        self.adId = adId
        self.created = created
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(id)" + "\(adId)" + title)
    }
}
