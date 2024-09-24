import Warp

public protocol SafetyElementContentViewDelegate: AnyObject {
    func safetyElementContentView(_ view: SafetyElementsView.ElementContentView, didClickOnLink identifier: String?, url: URL)
}

public extension SafetyElementsView {
    class ElementContentView: UIView {

        // MARK: - Public properties

        public weak var delegate: SafetyElementContentViewDelegate?

        // MARK: - Private properties

        private let linkButtonStyle = Button.Style.link.overrideStyle(normalFont: .body)
        private var topLink: LinkButtonViewModel?
        private var bottomLink: LinkButtonViewModel?
        private lazy var topLinkButton: Button = makeExternalLinkButton(onTap: #selector(didTapOnTopLink))
        private lazy var bottomLinkButton: Button = makeExternalLinkButton(onTap: #selector(didTapOnBottomLink))

        private lazy var contentStackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.spacing = Warp.Spacing.spacing100
            return stackView
        }()

        private lazy var contentLabel: Label = {
            let label = Label(style: .body, withAutoLayout: true)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()

        private lazy var emphasizedContentLabel: Label = {
            let label = Label(style: .bodyStrong, withAutoLayout: true)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()

        // MARK: - Init

        public override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        public required init?(coder aDecoder: NSCoder) { fatalError() }

        // MARK: - Public methods

        public func configure(with viewModel: SafetyElementViewModel) {
            configure(
                with: viewModel.body,
                emphasizedContent: viewModel.emphasizedBody,
                topLink: viewModel.topLink,
                bottomLink: viewModel.bottomLink
            )
        }

        public func configure(
            with content: String,
            emphasizedContent: String? = nil,
            topLink: LinkButtonViewModel? = nil,
            bottomLink: LinkButtonViewModel? = nil
        ) {
            self.topLink = topLink
            self.bottomLink = bottomLink
            contentLabel.text = content

            if let emphasizedContent {
                emphasizedContentLabel.text = emphasizedContent
                emphasizedContentLabel.isHidden = false
            } else {
                emphasizedContentLabel.isHidden = true
            }

            if let topLink {
                topLinkButton.setTitle(topLink.buttonTitle, for: .normal)
                topLinkButton.isHidden = false
            } else {
                topLinkButton.isHidden = true
            }

            if let bottomLink {
                bottomLinkButton.setTitle(bottomLink.buttonTitle, for: .normal)
                bottomLinkButton.isHidden = false
            } else {
                bottomLinkButton.isHidden = true
            }
        }

        // MARK: - Setup

        private func setup() {
            addSubview(contentStackView)

            contentStackView.addArrangedSubviews([
                topLinkButton,
                contentLabel,
                emphasizedContentLabel,
                bottomLinkButton,
            ])
            contentStackView.fillInSuperviewLayoutMargins()
        }

        // MARK: - Private methods

        @objc private func didTapOnBottomLink() {
            guard let bottomLink = bottomLink else { return }
            didTap(on: bottomLink)
        }

        @objc private func didTapOnTopLink() {
            guard let topLink = topLink else { return }
            didTap(on: topLink)
        }

        private func didTap(on externalLink: LinkButtonViewModel) {
            delegate?.safetyElementContentView(
                self,
                didClickOnLink: externalLink.buttonIdentifier,
                url: externalLink.linkUrl
            )
        }

        private func makeExternalLinkButton(onTap: Selector) -> Button {
            let button = Button(style: linkButtonStyle, withAutoLayout: true)
            button.isHidden = true
            button.contentEdgeInsets = .zero
            button.titleEdgeInsets = .zero
            button.titleLabel?.numberOfLines = 0
            button.contentHorizontalAlignment = .leading
            button.addTarget(self, action: onTap, for: .touchUpInside)
            return button
        }
    }
}
