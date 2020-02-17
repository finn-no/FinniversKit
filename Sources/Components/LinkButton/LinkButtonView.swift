//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

protocol LinkButtonViewDelegate: AnyObject {
    func linkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL)
}

class LinkButtonView: UIView {

    // MARK: - Internal properties

    weak var delegate: LinkButtonViewDelegate?

    // MARK: - Private properties

    private let buttonIdentifier: String?
    private let linkUrl: URL
    private let linkButtonStyle = Button.Style.link.overrideStyle(normalFont: .body)
    private lazy var fillerView = UIView(withAutoLayout: true)
    private lazy var externalImage = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topRowStackView, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()

    private lazy var topRowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [linkButton, fillerView, externalImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: linkButtonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private lazy var externalImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = externalImage
        imageView.tintColor = .externalIconColor
        return imageView
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .stone
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    convenience init(viewModel: LinkButtonViewModel) {
        self.init(buttonIdentifier: viewModel.buttonIdentifier, buttonTitle: viewModel.buttonTitle, subtitle: viewModel.subtitle, linkUrl: viewModel.linkUrl, isExternal: viewModel.isExternal)
    }

    init(buttonIdentifier: String?, buttonTitle: String, subtitle: String?, linkUrl: URL, isExternal: Bool) {
        self.buttonIdentifier = buttonIdentifier
        self.linkUrl = linkUrl
        super.init(frame: .zero)

        externalImageView.isHidden = !isExternal
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

        NSLayoutConstraint.activate([
            topRowStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    // MARK: - Private methods

    @objc private func handleTap() {
        delegate?.linkButton(withIdentifier: buttonIdentifier, wasTappedWithUrl: linkUrl)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var externalIconColor = dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
}
