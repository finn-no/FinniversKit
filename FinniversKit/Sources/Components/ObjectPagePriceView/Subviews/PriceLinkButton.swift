//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

protocol PriceLinkButtonViewDelegate: AnyObject {
    func priceLinkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL)
}

class PriceLinkButtonView: UIView {

    // MARK: - Internal properties

    weak var delegate: PriceLinkButtonViewDelegate?

    // MARK: - Private properties

    private let viewModel: PriceLinkButtonViewModel
    private let linkButtonStyle = Button.Style.link.overrideStyle(smallFont: .body)
    private lazy var fillerView = UIView(withAutoLayout: true)
    private lazy var externalImage = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [linkButton, fillerView, externalImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: linkButtonStyle, size: .small, withAutoLayout: true)
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

    private lazy var headingLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var subheadingLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .stone
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(viewModel: PriceLinkButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()

        if let heading = viewModel.heading, let subheading = viewModel.subheading {
            headingLabel.text = heading
            subheadingLabel.text = subheading
            stackView.addArrangedSubviews([headingLabel, subheadingLabel, subtitleLabel, buttonStackView])
            stackView.setCustomSpacing(.spacingXS, after: subheadingLabel)
        } else {
            stackView.addArrangedSubviews([buttonStackView, subtitleLabel])
        }

        externalImageView.isHidden = !viewModel.isExternal
        linkButton.setTitle(viewModel.buttonTitle, for: .normal)

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle?.isEmpty ?? true

        NSLayoutConstraint.activate([
            buttonStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    // MARK: - Private methods

    @objc private func handleTap() {
        delegate?.priceLinkButton(withIdentifier: viewModel.buttonIdentifier, wasTappedWithUrl: viewModel.linkUrl)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var externalIconColor = dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
}
