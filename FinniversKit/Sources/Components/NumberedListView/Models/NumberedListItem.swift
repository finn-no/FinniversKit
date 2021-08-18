import Foundation

public struct NumberedListItem {
    public let title: String?
    public let body: String
    public let actionButtonTitle: String?

    public init(title: String? = nil, body: String, actionButtonTitle: String? = nil) {
        self.title = title
        self.body = body
        self.actionButtonTitle = actionButtonTitle
    }
}
