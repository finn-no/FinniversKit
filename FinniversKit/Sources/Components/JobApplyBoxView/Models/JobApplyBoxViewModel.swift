import Foundation

public struct JobApplyBoxViewModel {
    public let title: String
    public let primaryButton: Button
    public let secondaryButton: Button?

    public init(title: String, primaryButton: Button, secondaryButton: Button? = nil) {
        self.title = title
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}

extension JobApplyBoxViewModel {
    public struct Button {
        public let title: String
        public let url: URL

        public init(title: String, url: URL) {
            self.title = title
            self.url = url
        }
    }
}
