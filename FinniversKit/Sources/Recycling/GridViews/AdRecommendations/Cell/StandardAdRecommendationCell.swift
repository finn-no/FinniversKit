import UIKit
import Warp

public final class StandardAdRecommendationCell: UICollectionViewCell, AdRecommendationCell, AdRecommendationConfigurable {

    // MARK: - Public properties

    public weak var delegate: AdRecommendationCellDelegate?
    public var indexPath: IndexPath?

    public weak var imageDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = imageDataSource
            logoImageView.dataSource = imageDataSource
        }
    }

    public var isFavorite = false {
        didSet {
            favoriteButton.isToggled = isFavorite
            guard let model else { return }
            let actionTitle = isFavorite
            ? model.favoriteButtonAccessibilityData.labelActiveState
            : model.favoriteButtonAccessibilityData.labelInactiveState
            let favoriteAction = UIAccessibilityCustomAction(
                name: actionTitle,
                target: self,
                selector: #selector(handleFavoriteButtonTap(_:))
            )
            accessibilityCustomActions = [favoriteAction]
        }
    }
    // MARK: - Private properties

    private var model: StandardAdRecommendationViewModel?

    /// Extra container to hold the accessibility elements in the order we want them read
    private lazy var containerView = UIView(withAutoLayout: true)
    private lazy var imageDescriptionStackView = UIStackView(axis: .horizontal, spacing: Self.margin, alignment: .center, withAutoLayout: true)
    private lazy var ribbonView = RibbonView(withAutoLayout: true)
    private lazy var imageTextLabel = Label(style: .captionStrong, textColor: .textInvertedStatic, withAutoLayout: true)
    private lazy var subtitleLabelHeightConstraint = subtitleLabel.heightAnchor.constraint(equalToConstant: Self.subtitleHeight * Config.accessibilityMultiplier())
    private lazy var accessoryLabelHeightConstraint = accessoryLabel.heightAnchor.constraint(equalToConstant: Self.accessoryHeight * Config.accessibilityMultiplier())

    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let bottomMargin: CGFloat = 15.0
    private static let subtitleHeight: CGFloat = 17.0
    private static let ribbonTopMargin: CGFloat = 6.0
    private static let ribbonHeight: CGFloat = 19.0
    private static let subtitleTopMargin: CGFloat = 6.0
    private static let accessoryHeight: CGFloat = 14.0
    private static let margin: CGFloat = 8.0
    private static let cornerRadius: CGFloat = 8.0
    private static let imageDescriptionHeight: CGFloat = 35.0
    private static let iconSize: CGFloat = 23.0
    private static let minImageAspectRatio: CGFloat = 0.75
    private static let maxImageAspectRatio: CGFloat = 1.5

    private let loadingColor: UIColor = .backgroundSubtle

    private var defaultImage: UIImage {
        UIImage(named: .noImage)
    }

    /// Height in cell that is not image
    private static var nonImageHeight: CGFloat {
        subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + bottomMargin
    }

    /// Height in cell that is not image including the height of accessory label
    private static var nonImageWithAccessoryHeight: CGFloat {
        subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + accessoryHeight + bottomMargin
    }

    private lazy var imageContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = Self.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconInverted
        return imageView
    }()

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.accessibilityTraits = .header
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, textColor: .textSubtle, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var accessoryLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var imageDescriptionBackgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView(withAutoLayout: true)
        view.effect = UIBlurEffect(style: .systemThinMaterialDark)
        view.alpha = 1.0
        view.layer.cornerRadius = Self.imageDescriptionHeight / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleFavoriteButtonTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var badgeView: BadgeView = {
        let badgeView = BadgeView()
        badgeView.attachToTopLeadingAnchor(in: imageView)
        return badgeView
    }()

    private lazy var subtitleToImageConstraint = subtitleLabel.topAnchor.constraint(
        equalTo: imageContentView.bottomAnchor,
        constant: Self.subtitleTopMargin
    )

    private lazy var subtitleToRibbonConstraint = subtitleLabel.topAnchor.constraint(
        equalTo: ribbonView.bottomAnchor,
        constant: Self.subtitleTopMargin
    )

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        containerView.addSubview(imageContentView)
        imageContentView.addSubview(imageView)
        imageContentView.addSubview(imageDescriptionBackgroundView)
        imageDescriptionBackgroundView.contentView.addSubview(imageDescriptionStackView)
        imageDescriptionStackView.fillInSuperview(insets: UIEdgeInsets(top: 0, leading: Self.margin, bottom: 0, trailing: -Self.margin), isActive: true)
        imageView.fillInSuperview()

        contentView.addSubview(containerView)
        containerView.addSubview(ribbonView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        containerView.addSubview(accessoryLabel)

        imageDescriptionStackView.addArrangedSubviews([iconImageView, imageTextLabel])

        backgroundColor = .clear

        let imageHeightMinimumConstraint = imageContentView.heightAnchor.constraint(equalTo: imageContentView.widthAnchor, multiplier: Self.minImageAspectRatio)
        let imageHeightMaximumConstraint = imageContentView.heightAnchor.constraint(lessThanOrEqualTo: imageContentView.widthAnchor, multiplier: Self.maxImageAspectRatio)

        imageHeightMinimumConstraint.priority = .defaultHigh

        containerView.fillInSuperview()

        NSLayoutConstraint.activate([
            imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageHeightMinimumConstraint,
            imageHeightMaximumConstraint,

            ribbonView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: Self.ribbonTopMargin),
            ribbonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ribbonView.heightAnchor.constraint(equalToConstant: Self.ribbonHeight * Config.accessibilityMultiplier()),

            logoImageView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: Warp.Spacing.spacing100),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),

            subtitleToImageConstraint,
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtitleLabelHeightConstraint,

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Self.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Self.titleHeight * Config.accessibilityMultiplier()),

            accessoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            accessoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accessoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.bottomMargin),
            accessoryLabelHeightConstraint,

            iconImageView.heightAnchor.constraint(equalToConstant: Self.iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: Self.iconSize),

            imageDescriptionBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing100),
            imageDescriptionBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            imageDescriptionBackgroundView.heightAnchor.constraint(equalToConstant: Self.imageDescriptionHeight),
            imageDescriptionBackgroundView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: -Warp.Spacing.spacing100),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -Warp.Spacing.spacing50),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Warp.Spacing.spacing50),
            favoriteButton.widthAnchor.constraint(equalToConstant: 48),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        favoriteButton.isAccessibilityElement = false
        containerView.isAccessibilityElement = true
        containerView.accessibilityTraits.insert(.button)
        accessibilityElements = [containerView]
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.alpha = 0.0
        imageView.contentMode = .scaleAspectFill
        imageContentView.backgroundColor = loadingColor
        iconImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        accessoryLabel.text = ""
        imageTextLabel.text = ""
        accessibilityCustomActions = []
        favoriteButton.setImage(nil, for: .normal)
        logoImageView.cancelLoading()
        logoImageView.image = nil
        iconImageView.isHidden = true
        imageTextLabel.isHidden = true
        imageDescriptionBackgroundView.isHidden = true
        badgeView.isHidden = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageContentView.layer.borderColor = .border
    }

    // MARK: - Public methods

    public func configure(with model: StandardAdRecommendationViewModel?, at indexPath: IndexPath) {
        self.model = model
        self.indexPath = indexPath

        iconImageView.image = model?.iconImage?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = model?.title
        subtitleLabel.text = model?.subtitle
        imageTextLabel.text = model?.imageText
        isFavorite = model?.isFavorite ?? false

        if let accessory = model?.accessory {
            accessoryLabel.text = accessory
            accessoryLabelHeightConstraint.constant = Self.accessoryHeight * Config.accessibilityMultiplier()
        } else {
            accessoryLabelHeightConstraint.constant = 0
        }

        if let subtitle = model?.subtitle {
            subtitleLabel.text = subtitle
            subtitleLabelHeightConstraint.constant = Self.subtitleHeight * Config.accessibilityMultiplier()
        } else {
            subtitleLabelHeightConstraint.constant = 0
        }

        ribbonView.style = .sponsored
        ribbonView.title = model?.sponsoredAdData?.ribbonTitle ?? ""
        ribbonView.isHidden = ribbonView.title.isEmpty

        NSLayoutConstraint.deactivate([subtitleToImageConstraint, subtitleToRibbonConstraint])
        NSLayoutConstraint.activate([ribbonView.title.isEmpty ? subtitleToImageConstraint : subtitleToRibbonConstraint])

        imageContentView.backgroundColor = loadingColor

        if model?.scaleImageToFillView == false {
            imageView.contentMode = .scaleAspectFit
            imageContentView.backgroundColor = .white
        }

        iconImageView.isHidden = iconImageView.image == nil
        imageTextLabel.isHidden = imageTextLabel.text == nil
        imageDescriptionBackgroundView.isHidden = model?.hideImageOverlay ?? false
        badgeView.isHidden = model?.badgeViewModel == nil

        if let badgeViewModel = model?.badgeViewModel {
            badgeView.configure(with: badgeViewModel)
        }

        containerView.accessibilityLabel = [
            model?.title,
            model?.badgeViewModel?.title,
            model?.imageText,
            model?.companyName,
            model?.subtitle,
            model?.accessory,
            model?.sponsoredAdData?.ribbonTitle,

            // Favorite button accessibility label
            isFavorite ? model?.favoriteButtonAccessibilityData.iconDescriptionActiveState : model?.favoriteButtonAccessibilityData.iconDescriptionInactiveState
        ]
            .compactMap { $0 }.joined(separator: ", ")
    }

    public static func height(for model: StandardAdRecommendationViewModel, width: CGFloat) -> CGFloat {
        let imageRatio = model.imageSize.height / model.imageSize.width
        let clippedImageRatio = min(max(imageRatio, Self.minImageAspectRatio), Self.maxImageAspectRatio)
        let imageHeight = width * clippedImageRatio
        var contentHeight = subtitleTopMargin
        + titleTopMargin
        + (titleHeight * Config.accessibilityMultiplier())
        + bottomMargin

        if model.accessory != nil {
            contentHeight += accessoryHeight
        }

        if model.sponsoredAdData?.ribbonTitle != nil {
            contentHeight += ribbonTopMargin + (ribbonHeight * Config.accessibilityMultiplier())
        }

        if model.subtitle != nil {
            contentHeight += (subtitleHeight * Config.accessibilityMultiplier())
        }

        return imageHeight + contentHeight
    }

    public static func extraHeight() -> CGFloat {
        nonImageHeight
    }

    public func loadImage() {
        if let imagePath = model?.imagePath {
            imageView.loadImage(for: imagePath, imageWidth: frame.size.width, fallbackImage: defaultImage)
        } else {
            setDefaultImage()
        }

        if logoImageView.image == nil {
            if let imagePath = model?.sponsoredAdData?.logoImagePath {
                logoImageView.isHidden = false
                logoImageView.loadImage(for: imagePath, imageWidth: frame.size.width / 3, fallbackImage: defaultImage)
            } else {
                logoImageView.isHidden = true
            }
        }
    }

    // MARK: - Private methods

    private func setDefaultImage() {
        imageView.image = defaultImage
        self.imageView.alpha = 1.0
    }

    @objc private func handleFavoriteButtonTap(_ button: UIButton) {
        delegate?.adRecommendationCell(self, didTapFavoriteButton: button)
    }
}
