//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

protocol LinkButtonViewDelegate: AnyObject {
    func linkButtonWasTapped(withUrl url: URL)
}

class LinkButtonView: UIView {

    // MARK: - Internal properties

    weak var delegate: LinkButtonViewDelegate?

    // MARK: - Private properties

    private let buttonIdentifier: String?
    private let linkUrl: URL
    private let linkButtonStyle = Button.Style.link.overrideStyle(normalFont: .body)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [linkButton, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: linkButtonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .stone
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    convenience init(viewModel: LinkButtonViewModel) {
        self.init(buttonIdentifier: viewModel.buttonIdentifier, buttonTitle: viewModel.buttonTitle, subtitle: viewModel.subtitle, linkUrl: viewModel.linkUrl)
    }

    init(buttonIdentifier: String?, buttonTitle: String, subtitle: String?, linkUrl: URL) {
        self.buttonIdentifier = buttonIdentifier
        self.linkUrl = linkUrl
        super.init(frame: .zero)

        linkButton.setTitle(buttonTitle, for: .normal)
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle?.isEmpty ?? true
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Private methods

    @objc private func handleTap() {
        delegate?.linkButtonWasTapped(withUrl: linkUrl)
    }
}
