public protocol HyperlinkTextViewViewModelDelegate: AnyObject {
    func didTapHyperlinkAction(_ action: String)
}

public struct HyperlinkTextViewViewModel {
    public let text: String
    public let hyperlinks: [Hyperlink]

    public weak var delegate: HyperlinkTextViewViewModelDelegate?

    public init(text: String, hyperlinks: [Hyperlink]) {
        self.text = text
        self.hyperlinks = hyperlinks
    }

    public func openLink(action: String) {
        delegate?.didTapHyperlinkAction(action)
    }
}

extension HyperlinkTextViewViewModel {
    public struct Hyperlink {
        public let hyperlink: String
        public let action: String

        public init(hyperlink: String, action: String) {
            self.hyperlink = hyperlink
            self.action = action
        }
    }
}
