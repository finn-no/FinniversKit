//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ContractActionViewDelegate: AnyObject {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL)
}

public class ContractActionView: UIView {
    // MARK: - Public properties

    public weak var delegate: ContractActionViewDelegate?
    private(set) var identifier: String?
    private(set) var buttonUrl: URL?

    // MARK: - Private properties

    private lazy var imageView: UIImageView = UIImageView(withAutoLayout: true)
    private lazy var imageViewTopAnchor = NSLayoutConstraint()
    private lazy var imageViewTrailingAnchor = NSLayoutConstraint()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var titleSubtitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .spacingXS
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bulletListLabel: Label = {
        let label = Label(withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private let buttonStyle = Button.Style.default.overrideStyle(borderColor: .btnDisabled)

    private lazy var actionButton: Button = {
        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)
        stackView.addArrangedSubviews([titleSubtitleStackView, descriptionLabel, bulletListLabel, actionButton])
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgTertiary
        layer.cornerRadius = .spacingS
        layoutMargins = UIEdgeInsets(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingL,
            trailing: .spacingM
        )

        addSubview(contentStackView)
        contentStackView.fillInSuperviewLayoutMargins()
    }

    // MARK: - Public methods

    public func configure(
        with viewModel: ContractActionViewModel,
        trailingImage: UIImage? = nil,
        trailingImageTopConstant: CGFloat = 0,
        trailingImageTrailingConstant: CGFloat = 0,
        contentSpacing: CGFloat = .spacingL,
        paragraphSpacing: CGFloat = 6
    ) {

        if let title = viewModel.title, !title.isEmpty {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        if let subtitle = viewModel.subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        if let description = viewModel.description, !description.isEmpty {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }

        contentStackView.spacing = contentSpacing

        self.identifier = viewModel.identifier
        self.buttonUrl = viewModel.buttonUrl

        bulletListLabel.attributedText = viewModel.strings.bulletPoints(withFont: .body, paragraphSpacing: paragraphSpacing)
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)

        guard let image = trailingImage else {
            imageView.removeFromSuperview()
            return
        }

        addImage(image, trailingImageTopConstant, trailingImageTrailingConstant)
    }

    // MARK: - Private methods

    @objc private func handleActionButtonTap() {
        guard let buttonUrl = buttonUrl else { return }
        delegate?.contractActionView(self, didSelectActionButtonWithUrl: buttonUrl)
    }

    private func addImage(_ image: UIImage, _ topConstant: CGFloat, _ trailingConstant: CGFloat) {
        imageView.image = image

        contentStackView.addSubview(imageView)
        contentStackView.sendSubviewToBack(imageView)

        if imageViewTopAnchor.isActive || imageViewTrailingAnchor.isActive {
            imageViewTopAnchor.constant = topConstant
            imageViewTrailingAnchor.constant = trailingConstant
        } else {
            imageViewTopAnchor = imageView.topAnchor.constraint(equalTo: topAnchor, constant: topConstant)
            imageViewTrailingAnchor = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant)
            NSLayoutConstraint.activate([imageViewTrailingAnchor, imageViewTopAnchor])
        }

    }
}
