//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol PriceLinkButtonViewDelegate: AnyObject {
    func priceLinkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL)
}

class PriceLinkButtonView: UIView {

    // MARK: - Internal properties

    weak var delegate: PriceLinkButtonViewDelegate?

    // MARK: - Private properties

    private let viewModel: PriceLinkButtonViewModel
    private lazy var fillerView = UIView(withAutoLayout: true)
    private lazy var externalImage = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([linkButton, fillerView, externalImageView])
        stackView.alignment = .center
        return stackView
    }()

    private lazy var linkButton: UIButton = {
        let button = PriceLinkButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
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
        label.textColor = .textSecondary
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

        externalImageView.isHidden = !viewModel.isExternal
        linkButton.setTitle(viewModel.buttonTitle, for: .normal)

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle?.isEmpty ?? true

        switch viewModel.kind {
        case .regular:
            configureForRegular()
        case .variantCompact:
            configureForVariantCompact()
        case .variantFull:
            configureForVariantFull()
        }
    }

    // MARK: - Private methods

    @objc private func handleTap() {
        delegate?.priceLinkButton(withIdentifier: viewModel.buttonIdentifier, wasTappedWithUrl: viewModel.linkUrl)
    }

    // MARK: - View configuration

    private func configureForRegular() {
        stackView.addArrangedSubviews([buttonStackView, subtitleLabel])

        NSLayoutConstraint.activate([
            buttonStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func configureForVariantCompact() {
        subheadingLabel.text = viewModel.subheading
        subheadingLabel.setContentHuggingPriority(.required, for: .horizontal)

        let horizontalStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        horizontalStackView.addArrangedSubviews([subheadingLabel, buttonStackView])

        stackView.addArrangedSubviews([horizontalStackView, subtitleLabel])

        NSLayoutConstraint.activate([
            horizontalStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func configureForVariantFull() {
        headingLabel.text = viewModel.heading
        subheadingLabel.text = viewModel.subheading
        stackView.addArrangedSubviews([headingLabel, subheadingLabel, subtitleLabel, buttonStackView])
        stackView.setCustomSpacing(.spacingXS, after: subheadingLabel)

        NSLayoutConstraint.activate([
            buttonStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}

// MARK: - Private types/extensions

private extension UIColor {
    static var externalIconColor = dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
}

private class PriceLinkButton: UIButton {
    override var intrinsicContentSize: CGSize {
        /// We need to override this to get the correct height for button with multiple lines of text.
        guard let titleSize = titleLabel?.intrinsicContentSize else { return .zero }

        return CGSize(
            width: titleSize.width,
            height: titleSize.height + 10 // 2 * .spacingXS + 2 (aka. magic number).
        )
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel?.font = .body
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping

        titleEdgeInsets = .zero
        contentEdgeInsets = UIEdgeInsets(vertical: .spacingXS, horizontal: 0)
        contentHorizontalAlignment = .leading

        setTitleColor(.textAction, for: .normal)
        setTitleColor(.linkButtonHighlightedTextColor, for: .highlighted)
        setTitleColor(.textDisabled, for: .disabled)
    }

    // MARK: - Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.size.width ?? 0
    }
}
