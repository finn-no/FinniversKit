import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: Int
    public let created: Date
    public let isRead: Bool

    private let identifier = UUID()

    public init(id: Int, title: String, imageUrlString: String?, created: Date = Date(), isRead: Bool) {
        self.title = title
        self.imageUrlString = imageUrlString
        self.id = id
        self.created = created
        self.isRead = isRead
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
