//
//  Copyright © 2020 FINN AS. All rights reserved.
//

protocol SafetyElementContentViewDelegate: AnyObject {
    func safetyElementContentView(_ view: SafetyElementContentView, didClickOnLink identifier: String?, url: URL)
}

class SafetyElementContentView: UIView {
    weak var delegate: SafetyElementContentViewDelegate?

    private var viewModel: SafetyElementViewModel?

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = .mediumSpacing
        return stackView
    }()

    private let linkButtonStyle = Button.Style.link.overrideStyle(normalFont: .body)

    private lazy var contentLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var externalLinkButton: Button = {
        let button = Button(style: linkButtonStyle, withAutoLayout: true)
        button.isHidden = true
        button.contentEdgeInsets = .zero
        button.titleEdgeInsets = .zero
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapOnLink), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    func configure(with viewModel: SafetyElementViewModel) {
        self.viewModel = viewModel
        contentLabel.text = viewModel.body
        if let externalLink = viewModel.externalLink {
            externalLinkButton.setTitle(externalLink.buttonTitle, for: .normal)
            externalLinkButton.isHidden = false
        } else {
            externalLinkButton.isHidden = true
        }
    }

    private func setup() {
        addSubview(contentStackView)

        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(externalLinkButton)
        contentStackView.fillInSuperviewLayoutMargins()
    }

    @objc private func didTapOnLink() {
        guard let externalLink = viewModel?.externalLink else { return }
        delegate?.safetyElementContentView(
            self,
            didClickOnLink: externalLink.buttonIdentifier,
            url: externalLink.linkUrl
        )
    }
}
