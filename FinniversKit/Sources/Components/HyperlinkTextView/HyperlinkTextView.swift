public class HyperlinkTextView: UIView {
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

    public override var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }

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

    public var linkColor: UIColor = .textAction {
        didSet {
            updateText()
        }
    }

    public init(frame: CGRect = .zero, withAutoLayout: Bool) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(textView)
        textView.fillInSuperview()
    }

    public func configure(viewModel: HyperlinkTextViewViewModel) {
        self.viewModel = viewModel

        updateText()
    }

    private func updateText() {
        guard let viewModel = viewModel else { return }

        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: viewModel.text)
        for hyperlink in viewModel.hyperlinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperlink.hyperlink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: hyperlink.action, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        }

        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: linkColor
        ]

        textView.attributedText = attributedOriginalText
    }
}

extension HyperlinkTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        viewModel?.openLink(action: URL.absoluteString)
        return false
    }
}
