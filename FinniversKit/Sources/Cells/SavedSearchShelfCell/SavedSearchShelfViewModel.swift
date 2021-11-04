import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: String
    
    public init(title: String, imageUrlString: String?) {
        self.title = title
        self.imageUrlString = imageUrlString
        id = UUID().uuidString
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + title)
    }
}
