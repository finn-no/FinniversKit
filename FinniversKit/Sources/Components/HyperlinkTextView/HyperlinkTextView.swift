public class HyperlinkTextView: UIView {
    public var font: UIFont = .body {
        didSet {
            textView.font = font
            updateText()
        }
    }

    public var textColor: UIColor = .textPrimary {
        didSet {
            textView.textColor = textColor
            updateText()
        }
    }

    public override var backgroundColor: UIColor? {
        didSet {
            textView.backgroundColor = backgroundColor
        }
    }

    public var linkColor: UIColor = .textAction {
        didSet {
            updateText()
        }
    }

    public var textAlignment: NSTextAlignment = .left {
        didSet {
            updateText()
        }
    }

    // MARK: - Private properties

    private var viewModel: HyperlinkTextViewViewModel?

    private lazy var textView: UITextView = {
        let view = UITextView(frame: .zero, textContainer: nil)
        view.font = font
        view.textColor = textColor
        view.isScrollEnabled = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        view.isEditable = false
        view.isSelectable = true
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0

        return view
    }()

    // MARK: - Init

    public init(frame: CGRect = .zero, withAutoLayout: Bool) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    public func configure(with viewModel: HyperlinkTextViewViewModel) {
        self.viewModel = viewModel

        updateText()
    }

    // MARK: - Overrides

    public override var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateText()
    }

    // MARK: - Private functions

    private func setup() {
        addSubview(textView)
        textView.fillInSuperview()
    }

    private func updateText() {
        guard let viewModel = viewModel else { return }

        let parser = HTMLStringParser()
        let translator = HyperLinkTextViewTranslator(
            links: viewModel.hyperlinks,
            textColor: textColor,
            textAlignment: textAlignment
        )
        let attributedText = try? parser.parse(
            html: viewModel.htmlText,
            translator: translator
        )

        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: linkColor
        ]

        textView.attributedText = attributedText
    }
}

extension HyperlinkTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        viewModel?.openLink(action: URL.absoluteString)
        return false
    }
}

private struct HyperLinkTextViewTranslator: HTMLStringParserTranslator {
    let links: [HyperlinkTextViewViewModel.Hyperlink]
    let textColor: UIColor
    let textAlignment: NSTextAlignment

    public func translate(tokens: [HTMLLexer.Token]) throws -> NSAttributedString {
        var styledText = NSMutableAttributedString()
        var currentTag: String?

        for token in tokens {
            switch token {
            case .startTag(let name, _, _):
                currentTag = name

            case .endTag:
                currentTag = nil

            case .text(let string):
                let style = NSMutableParagraphStyle()
                style.alignment = textAlignment

                var attributes: [NSAttributedString.Key : Any] = [
                    .paragraphStyle: style,
                    .foregroundColor: textColor
                ]

                if let currentTag,
                   let hyperlink = links.first(where: { $0.hyperlink == currentTag }) {
                    attributes[.link] = hyperlink.action
                }

                let attributedText = NSAttributedString(string: string, attributes: attributes)
                styledText.append(attributedText)

            default:
                break
            }
        }
        return styledText
    }
}
