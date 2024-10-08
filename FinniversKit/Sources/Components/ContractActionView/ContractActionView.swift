//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public protocol ContractActionViewDelegate: AnyObject {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL)
}

public class ContractActionView: UIView {
    // MARK: - Public properties

    public weak var delegate: ContractActionViewDelegate?
    public private(set) var identifier: String?
    public private(set) var buttonUrl: URL?

    // MARK: - Private properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: false)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var imageViewTopAnchor = NSLayoutConstraint()
    private lazy var imageViewTrailingAnchor = NSLayoutConstraint()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3, withAutoLayout: true)
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
        stackView.spacing = Warp.Spacing.spacing50
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
        label.isHidden = true
        return label
    }()


    private let buttonStyle = Button.Style.default.overrideStyle(borderColor: .backgroundDisabled)

    private lazy var actionButton: Button = {
        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing300, withAutoLayout: true)
        stackView.addArrangedSubviews([imageView, titleSubtitleStackView, bulletListLabel, descriptionLabel, actionButton])
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
        backgroundColor = .backgroundSubtle
        layer.cornerRadius = Warp.Spacing.spacing100
        layoutMargins = UIEdgeInsets(
            top: Warp.Spacing.spacing200,
            leading: Warp.Spacing.spacing200,
            bottom: Warp.Spacing.spacing300,
            trailing: Warp.Spacing.spacing200
        )

        addSubview(contentStackView)
        contentStackView.fillInSuperviewLayoutMargins()
    }

    // MARK: - Public methods

    public func configure(
        with viewModel: ContractActionViewModel,
        topIcon: UIImage? = nil,
        trailingImageTopConstant: CGFloat = 0,
        trailingImageTrailingConstant: CGFloat = 0,
        contentSpacing: CGFloat = Warp.Spacing.spacing300,
        paragraphSpacing: CGFloat = 6,
        remoteImageViewDataSource: RemoteImageViewDataSource? = nil
    ) {
        identifier = viewModel.identifier
        buttonUrl = viewModel.buttonUrl

        if let icon = topIcon {
            imageView.image = icon
        }

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


        contentStackView.spacing = contentSpacing
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)

        if let stringArray = viewModel.strings, !stringArray.isEmpty {
            bulletListLabel.attributedText = stringArray.bulletPoints(withFont: .body, paragraphSpacing: paragraphSpacing)
            bulletListLabel.isHidden = false
        } else {
            bulletListLabel.isHidden = true
        }

    }

    // MARK: - Private methods

    @objc private func handleActionButtonTap() {
        guard let buttonUrl = buttonUrl else { return }
        delegate?.contractActionView(self, didSelectActionButtonWithUrl: buttonUrl)
    }
}
