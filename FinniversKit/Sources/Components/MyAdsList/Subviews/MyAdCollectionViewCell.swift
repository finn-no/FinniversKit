import UIKit

public class MyAdCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    private let imageWidth: CGFloat = 80
    private lazy var fallbackImage = UIImage(named: .noImage).withRenderingMode(.alwaysTemplate)
    private lazy var titleLabel = Label(style: .bodyStrong, numberOfLines: 2, withAutoLayout: true)
    private lazy var subtitleLabel = Label(style: .caption, textColor: .textSecondary, withAutoLayout: true)
    private lazy var ribbonView = RibbonView(withAutoLayout: true)
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var statisticsStackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .spacingS
        imageView.layer.borderWidth = 1 / UIScreen.main.scale
        imageView.tintColor = .textSecondary
        imageView.backgroundColor = .backgroundInfoSubtle
        return imageView
    }()

    private lazy var expiresLabel: Label = {
        let label = Label(style: .detail, numberOfLines: 2, textColor: .textSecondary, withAutoLayout: true)
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.accessibilityTraits = .header
        textStackView.addArrangedSubviews([titleLabel, subtitleLabel])

        contentView.addSubview(remoteImageView)
        contentView.addSubview(textStackView)
        contentView.addSubview(ribbonView)
        contentView.addSubview(statisticsStackView)
        contentView.addSubview(expiresLabel)
        contentView.addSubview(hairlineView)

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            remoteImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.spacingM),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            remoteImageView.heightAnchor.constraint(equalToConstant: imageWidth),

            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            textStackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .spacingM),
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: ribbonView.leadingAnchor, constant: -.spacingM),

            ribbonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            ribbonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            statisticsStackView.topAnchor.constraint(greaterThanOrEqualTo: textStackView.bottomAnchor, constant: .spacingM),
            statisticsStackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .spacingM),
            statisticsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM),

            expiresLabel.topAnchor.constraint(greaterThanOrEqualTo: textStackView.bottomAnchor, constant: .spacingM),
            expiresLabel.leadingAnchor.constraint(equalTo: statisticsStackView.trailingAnchor, constant: .spacingM),
            expiresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            expiresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM),

            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            hairlineView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .spacingM),
            hairlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        remoteImageView.cancelLoading()
        statisticsStackView.removeArrangedSubviews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        remoteImageView.layer.borderColor = UIColor.imageBorder.cgColor
    }

    // MARK: - Internal methods

    public func configure(ad: MyAdModel, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        remoteImageView.image = fallbackImage
        remoteImageView.backgroundColor = .backgroundInfoSubtle

        remoteImageView.dataSource = remoteImageViewDataSource
        if let imageUrl = ad.imageUrl {
            remoteImageView.loadImage(for: imageUrl, imageWidth: imageWidth, loadingColor: .backgroundInfoSubtle, fallbackImage: fallbackImage)
        }

        titleLabel.text = ad.title

        expiresLabel.text = ad.expires?.title
        expiresLabel.accessibilityLabel = ad.expires?.accessibilityTitle

        subtitleLabel.text = ad.subtitle
        subtitleLabel.isHidden = ad.subtitle == nil

        ribbonView.configure(with: ad.ribbon)

        statisticsStackView.addArrangedSubviews([
            MyAdStatisticsItemView(model: ad.statisticFavorites, iconName: .statsHeart, withAutoLayout: true),
            MyAdStatisticsItemView(model: ad.statisticViews, iconName: .view, withAutoLayout: true)
        ])

        updateConstraintsIfNeeded()
    }
}
