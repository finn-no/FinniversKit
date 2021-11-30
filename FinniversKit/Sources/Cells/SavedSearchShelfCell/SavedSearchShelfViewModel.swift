import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: Int
    public let created: Date
    
    private let identifier = UUID()
    
    public init(id: Int, title: String, imageUrlString: String?, created: Date = Date()) {
        self.title = title
        self.imageUrlString = imageUrlString
        self.id = id
        self.created = created
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
