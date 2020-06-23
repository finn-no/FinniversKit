//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

final class NotificationCell: UITableViewCell {

    // MARK: - Internal properties

    var remoteImageViewDataSource: RemoteImageViewDataSource? {
        get { remoteImageView.dataSource }
        set { remoteImageView.dataSource = newValue }
    }

    // MARK: - Private properties

    private lazy var remoteImageView: RemoteImageView = {
       let imageView = RemoteImageView(withAutoLayout: true)
       imageView.contentMode = .scaleAspectFill
       imageView.layer.cornerRadius = 8
       imageView.layer.masksToBounds = true
       return imageView
    }()

    private lazy var iconView = PersonalNotificationIconView(
        withAutoLayout: true
    )

    private lazy var ribbonView = RibbonView(
        withAutoLayout: true
    )

    private lazy var titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 2
        label.textColor = .textAction
        return label
    }()

    private lazy var priceLabel = Label(
        style: .bodyStrong,
        withAutoLayout: true
    )

    private lazy var timestampLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, priceLabel, timestampLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(.spacingS, after: subtitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView(withAutoLayout: true)
        separatorView.backgroundColor = .tableViewSeparator
        return separatorView
    }()

    private lazy var gradientLayer = CAGradientLayer()

    private let imageWidth: CGFloat = 80
    private let fallbackImage = UIImage(named: .noImage)

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.colors = [
            UIColor.bgPrimary.withAlphaComponent(0).cgColor,
            UIColor.bgPrimary.cgColor
        ]

        gradientLayer.frame = contentView.bounds
    }

    override func prepareForReuse() {
        remoteImageView.cancelLoading()
        remoteImageView.setImage(nil, animated: false)
        iconView.isHidden = true
        ribbonView.isHidden = true
        detailLabel.isHidden = true
        stackView.setCustomSpacing(0, after: priceLabel)
        configure(with: nil, timestamp: nil, hideSeparator: false, showGradient: false)
    }

    func configure(with model: NotificationCellModel?, timestamp: String?, hideSeparator: Bool, showGradient: Bool) {
        backgroundColor = model?.isRead == true ? .bgPrimary : .bgSecondary

        timestampLabel.text = timestamp
        separatorView.isHidden = hideSeparator
        gradientLayer.isHidden = !showGradient

        priceLabel.text = model?.content?.priceText
        priceLabel.isHidden = model?.content?.priceText == nil

        switch model?.content {
        case let content as PersonalNotificationCellContent:
            titleLabel.font = .body
            titleLabel.text = content.description
            subtitleLabel.font = .bodyStrong
            subtitleLabel.text = content.title
            iconView.configure(with: content.icon)
            iconView.isHidden = false
        case let content as SavedSearchNotificationCellContent:
            titleLabel.font = .detail
            titleLabel.text = content.locationText
            subtitleLabel.font = model?.isRead == true ? .body : .bodyStrong
            subtitleLabel.text = content.title

            if let ribbonViewModel = content.ribbonViewModel {
                ribbonView.configure(with: ribbonViewModel)
                ribbonView.isHidden = false
            }
        default:
            break
        }

        if case let content as FavoriteSoldNotificationCellContent = model?.content {
            titleLabel.font = .caption
            subtitleLabel.font = .body

            if let detail = content.detail,
                let priceLabelIndex = stackView.arrangedSubviews.firstIndex(of: priceLabel) {
                detailLabel.text = detail
                detailLabel.isHidden = false
                stackView.insertArrangedSubview(detailLabel, at: priceLabelIndex + 1)
                stackView.setCustomSpacing(.spacingS, after: detailLabel)
                stackView.setCustomSpacing(.spacingS, after: priceLabel)
            }

            if let ribbonViewModel = content.ribbonViewModel {
                ribbonView.configure(with: ribbonViewModel)
                ribbonView.isHidden = false
            }
        }

        guard let imagePath = model?.content?.imagePath else {
            remoteImageView.setImage(fallbackImage, animated: false)
            return
        }

        remoteImageView.loadImage(for: imagePath, imageWidth: imageWidth, loadingColor: nil, fallbackImage: fallbackImage)
    }
}

// MARK: - Private extension
private extension NotificationCell {
    func setup() {
        setDefaultSelectedBackgound()

        contentView.addSubview(remoteImageView)
        contentView.addSubview(iconView)
        contentView.addSubview(ribbonView)
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
        contentView.layer.addSublayer(gradientLayer)

        NSLayoutConstraint.activate([
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            remoteImageView.heightAnchor.constraint(equalToConstant: imageWidth),

            iconView.centerXAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: -.spacingS),
            iconView.centerYAnchor.constraint(equalTo: remoteImageView.bottomAnchor, constant: -.spacingS),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            ribbonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            ribbonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS),

            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .spacingM),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            separatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: .spacingM),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: remoteImageView.bottomAnchor, constant: .spacingM)
        ])
    }
}
