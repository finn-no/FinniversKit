import Foundation

public struct ScrollableTabViewModel {
    let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}

extension ScrollableTabViewModel {
    public struct Item {
        public let identifier: String
        public let title: String

        public init(identifier: String, title: String) {
            self.identifier = identifier
            self.title = title
        }
    }
}
