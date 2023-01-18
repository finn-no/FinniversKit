import Foundation

public struct FrontPageSavedSearchViewModel {
    public let title: String
    public let imageUrl: String?
    public let id: Int
    public let isRead: Bool

    private let identifier = UUID()

    public init(id: Int, title: String, imageUrl: String?, isRead: Bool) {
        self.title = title
        self.imageUrl = imageUrl
        self.id = id
        self.isRead = isRead
    }
}

extension FrontPageSavedSearchViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
