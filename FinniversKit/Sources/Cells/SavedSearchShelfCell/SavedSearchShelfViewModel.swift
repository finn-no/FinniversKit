import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: String
    public let adId: String
    
    public init(id: String = UUID().uuidString, title: String, imageUrlString: String?, adId: String = UUID().uuidString) {
        self.title = title
        self.imageUrlString = imageUrlString
        self.id = id
        self.adId = adId
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + title)
    }
}
