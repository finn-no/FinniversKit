//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

final class UserAdDetailsView: UIView {

    // MARK: - Public properties

    var adImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            adImageView.dataSource = adImageViewDataSource
        }
    }

    var loadingColor: UIColor? = .toothPaste

    // MARK: - Private properties

    private var model: UserAdTableViewCellViewModel?

    private lazy var fallbackImage = UIImage(named: .noImage)

    private lazy var ribbonView: RibbonView = {
        let view = RibbonView(withAutoLayout: true)
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    private lazy var adImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = .spacingM
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.backgroundColor = .clear
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption)
        label.isHidden = true
        label.backgroundColor = .clear
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.isHidden = true
        label.backgroundColor = .clear
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()

    private lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()

    private lazy var adImageWidthConstraint = adImageView.widthAnchor.constraint(equalToConstant: UserAdTableViewCell.Style.default.imageSize)
    private lazy var adImageHeightConstraint = adImageView.heightAnchor.constraint(equalToConstant: UserAdTableViewCell.Style.default.imageSize)

    private lazy var topSpacer = UILayoutGuide()
    private lazy var bottomSpacer = UILayoutGuide()

    private lazy var defaultConstraints = [
        bottomSpacer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

        descriptionStack.topAnchor.constraint(greaterThanOrEqualTo: ribbonView.bottomAnchor, constant: .spacingXXS),
        descriptionStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        descriptionStack.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),
        descriptionStack.centerYAnchor.constraint(equalTo: adImageView.centerYAnchor),

        ribbonView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
    ]

    private lazy var compressedConstraints = [
        topSpacer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),

        bottomSpacer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        bottomSpacer.heightAnchor.constraint(equalTo: topSpacer.heightAnchor),

        descriptionStack.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
        descriptionStack.trailingAnchor.constraint(equalTo: ribbonView.leadingAnchor, constant: -.spacingS),
        descriptionStack.bottomAnchor.constraint(equalTo: bottomSpacer.topAnchor),

        ribbonView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(adImageView)

        addSubview(descriptionStack)
        addSubview(ribbonView)

        addLayoutGuide(topSpacer)
        addLayoutGuide(bottomSpacer)

        descriptionStack.addArrangedSubview(titleLabel)
        descriptionStack.addArrangedSubview(subtitleLabel)
        descriptionStack.addArrangedSubview(detailLabel)

        descriptionStack.setCustomSpacing(.spacingXXS, after: titleLabel)
        descriptionStack.setCustomSpacing(.spacingS, after: subtitleLabel)

        let constraints = defaultConstraints + [
            descriptionStack.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .spacingM),

            ribbonView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            adImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            adImageView.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
            adImageView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
            adImageView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
            adImageHeightConstraint,
            adImageWidthConstraint,
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Public methods

    func configure(with style: UserAdTableViewCell.Style, model: UserAdTableViewCellViewModel) {
        self.model = model

        titleLabel.text = model.titleText
        titleLabel.numberOfLines = style == .compressed ? 1 : 2

        subtitleLabel.text = model.subtitleText ?? " "
        subtitleLabel.isHidden = false

        if let detail = model.detailText {
            detailLabel.text = detail
            detailLabel.isHidden = style == .compressed
        }

        ribbonView.configure(with: model.ribbonViewModel)

        adImageHeightConstraint.constant = style.imageSize
        adImageWidthConstraint.constant = style.imageSize

        NSLayoutConstraint.deactivate(style == .compressed ? defaultConstraints : compressedConstraints)
        NSLayoutConstraint.activate(style == .compressed ? compressedConstraints : defaultConstraints)
    }

    func loadImage() {
        guard let imagePath = model?.imagePath else {
            adImageView.image = fallbackImage
            return
        }

        adImageView.loadImage(
            for: imagePath,
            imageWidth: UserAdTableViewCell.Style.default.imageSize,
            loadingColor: loadingColor,
            fallbackImage: fallbackImage
        )
    }

    func resetContent() {
        ribbonView.title = ""
        ribbonView.style = .default

        adImageView.cancelLoading()
        adImageView.image = nil

        titleLabel.text = nil

        [subtitleLabel, detailLabel].forEach {
            $0.text = nil
            $0.isHidden = true
        }
    }
}
