import Foundation

public struct ScrollableTabViewModel: Hashable {
    public let selectedIdentifier: String?
    public let items: [Item]

    public init(selectedIdentifier: String? = nil, items: [Item]) {
        self.selectedIdentifier = selectedIdentifier
        self.items = items
    }
}

extension ScrollableTabViewModel {
    public struct Item: Hashable {
        public let identifier: String
        public let title: String

        public init(identifier: String, title: String) {
            self.identifier = identifier
            self.title = title
        }
    }
}
