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

    private lazy var ribbonView = RibbonView(withAutoLayout: true)

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
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption)
        label.isHidden = true
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.isHidden = true
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = .spacingM
        return stackView
    }()

    private lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(withAutoLayout: false)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()

    private lazy var contentStackTopAnchor = contentStack.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM)
    private lazy var contentStackBottomAnchor = contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
    private lazy var adImageWidthConstraint = adImageView.widthAnchor.constraint(equalToConstant: UserAdTableViewCell.Style.default.imageSize)
    private lazy var adImageHeightConstraint = adImageView.heightAnchor.constraint(equalToConstant: UserAdTableViewCell.Style.default.imageSize)

    private lazy var ribbonViewTopAnchor: NSLayoutConstraint = {
        let constraint = ribbonView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS)
        constraint.isActive = false
        return constraint
    }()

    private lazy var ribbonViewCenterYAnchor: NSLayoutConstraint = {
        let constraint = ribbonView.centerYAnchor.constraint(equalTo: centerYAnchor)
        constraint.isActive = false
        return constraint
    }()

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
        addSubview(contentStack)
        addSubview(ribbonView)

        contentStack.addArrangedSubview(adImageView)
        contentStack.addArrangedSubview(descriptionStack)

        descriptionStack.addArrangedSubview(titleLabel)
        descriptionStack.addArrangedSubview(subtitleLabel)
        descriptionStack.addArrangedSubview(detailLabel)

        descriptionStack.setCustomSpacing(.spacingXXS, after: titleLabel)
        descriptionStack.setCustomSpacing(.spacingS, after: subtitleLabel)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            contentStack.trailingAnchor.constraint(equalTo: ribbonView.leadingAnchor, constant: -.spacingS),
            contentStackTopAnchor,
            contentStackBottomAnchor,

            ribbonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            ribbonViewTopAnchor,

            adImageHeightConstraint,
            adImageWidthConstraint,

        ])
    }

    // MARK: - Public methods

    func configure(with style: UserAdTableViewCell.Style, model: UserAdTableViewCellViewModel) {
        self.model = model

        contentStack.alignment = style == .compressed ? .center : .top

        titleLabel.text = model.titleText
        titleLabel.numberOfLines = style == .compressed ? 1 : 2

        if let subtitle = model.subtitleText {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        }

        if let detail = model.detailText {
            detailLabel.text = detail
            detailLabel.isHidden = style == .compressed
        }

        ribbonView.configure(with: model.ribbonViewModel)

        contentStackTopAnchor.constant = style == .compressed ? .spacingS : .spacingM
        contentStackBottomAnchor.constant = style == .compressed ? -.spacingS : -.spacingM
        ribbonViewTopAnchor.isActive = style == .default
        ribbonViewCenterYAnchor.isActive = style == .compressed
        adImageHeightConstraint.constant = style.imageSize
        adImageWidthConstraint.constant = style.imageSize
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
