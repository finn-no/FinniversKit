public protocol HyperlinkTextViewViewModelDelegate: AnyObject {
    func didTapHyperlinkAction(_ action: String)
}

public class HyperlinkTextViewModel: Equatable {
    public let htmlText: String
    public let hyperlinks: [Hyperlink]

    public weak var delegate: HyperlinkTextViewViewModelDelegate?

    public init(text: String, hyperlinks: [Hyperlink]) {
        self.htmlText = text
        self.hyperlinks = hyperlinks
    }

    public func openLink(action: String) {
        delegate?.didTapHyperlinkAction(action)
    }

    public static func == (lhs: HyperlinkTextViewModel, rhs: HyperlinkTextViewModel) -> Bool {
        lhs.htmlText == rhs.htmlText && lhs.hyperlinks == rhs.hyperlinks
    }
}

extension HyperlinkTextViewModel {
    public struct Hyperlink: Equatable {
        public let hyperlink: String
        public let action: String

        public init(hyperlink: String, action: String) {
            self.hyperlink = hyperlink
            self.action = action
        }

        public static func == (lhs: Hyperlink, rhs: Hyperlink) -> Bool {
            lhs.action == rhs.action && lhs.hyperlink == rhs.hyperlink
        }
    }
}
