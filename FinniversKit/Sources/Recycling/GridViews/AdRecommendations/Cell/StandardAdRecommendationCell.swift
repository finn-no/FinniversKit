//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class StandardAdRecommendationCell: UICollectionViewCell, AdRecommendationCell, AdRecommendationConfigurable {

    // MARK: - Internal properties

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

    /// Extra container for accessibility issues. The cell should have "all content" and favoriteButton as accessibilty elements but it get confused if favoriteButton is a subview of the other accessibility element (so contentView can not be one of the accessibility elements
    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        return view
    }()

    private lazy var imageContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = StandardAdRecommendationCell.cornerRadius
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
        imageView.tintColor = .iconTertiary
        return imageView
    }()

    private lazy var ribbonView = RibbonView(withAutoLayout: true)

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var accessoryLabel: Label = {
        let label = Label(style: .detailStrong)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var imageDescriptionBackgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView(withAutoLayout: true)
        view.effect = UIBlurEffect(style: .systemThinMaterialDark)
        view.alpha = 1.0
        view.layer.cornerRadius = StandardAdRecommendationCell.imageDescriptionHeight / 2
        view.clipsToBounds = true
        return view
    }()

    private lazy var imageDescriptionStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: StandardAdRecommendationCell.margin, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var imageTextLabel: Label = {
        let label = Label(style: .captionStrong)
        label.textColor = .textTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFavoriteButtonTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var subtitleToImageConstraint = subtitleLabel.topAnchor.constraint(
        equalTo: imageContentView.bottomAnchor,
        constant: StandardAdRecommendationCell.subtitleTopMargin
    )

    private lazy var subtitleToRibbonConstraint = subtitleLabel.topAnchor.constraint(
        equalTo: ribbonView.bottomAnchor,
        constant: StandardAdRecommendationCell.subtitleTopMargin
    )

    private var model: StandardAdRecommendationViewModel?

    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor? {
        didSet {
            imageContentView.backgroundColor = loadingColor
        }
    }

    /// A data source for the loading of the image
    public weak var imageDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = imageDataSource
            logoImageView.dataSource = imageDataSource
        }
    }

    /// A delegate for actions triggered from the cell
    public weak var delegate: AdRecommendationCellDelegate?

    /// Optional index of the cell
    public var index: Int?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
        let accessibilityMultiplier: CGFloat = {
            switch self.traitCollection.preferredContentSizeCategory {
            case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
                return 2.5
            case UIContentSizeCategory.accessibilityExtraExtraLarge:
                return 2.25
            case UIContentSizeCategory.accessibilityExtraLarge:
                return 2.0
            case UIContentSizeCategory.accessibilityLarge:
                return 1.75
            case UIContentSizeCategory.accessibilityMedium:
                return 1.5
            default:
                return 1.0
            }
        }()
        containerView.isAccessibilityElement = true
        favoriteButton.isAccessibilityElement = true
        accessibilityElements = [containerView, favoriteButton]
        shouldGroupAccessibilityChildren = true
        containerView.accessibilityTraits.insert(.button)
        imageView.accessibilityElementsHidden = true

        containerView.addSubview(imageContentView)
        imageContentView.addSubview(imageView)
        imageContentView.addSubview(imageDescriptionBackgroundView)
        imageDescriptionBackgroundView.contentView.addSubview(imageDescriptionStackView)
        imageDescriptionStackView.fillInSuperview(insets: UIEdgeInsets(top: 0, leading: StandardAdRecommendationCell.margin, bottom: 0, trailing: -StandardAdRecommendationCell.margin), isActive: true)
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

        let imageHeightMinimumConstraint = imageContentView.heightAnchor.constraint(equalTo: imageContentView.widthAnchor, multiplier: StandardAdRecommendationCell.minImageAspectRatio)
        let imageHeightMaximumConstraint = imageContentView.heightAnchor.constraint(lessThanOrEqualTo: imageContentView.widthAnchor, multiplier: StandardAdRecommendationCell.maxImageAspectRatio)

        imageHeightMinimumConstraint.priority = .defaultHigh

        containerView.fillInSuperview()

        NSLayoutConstraint.activate([
            imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageHeightMinimumConstraint,
            imageHeightMaximumConstraint,

            ribbonView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: StandardAdRecommendationCell.ribbonTopMargin),
            ribbonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ribbonView.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.ribbonHeight * accessibilityMultiplier),

            logoImageView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: .spacingS),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),

            subtitleToImageConstraint,
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.subtitleHeight*accessibilityMultiplier),

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: StandardAdRecommendationCell.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.titleHeight*accessibilityMultiplier),

            accessoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            accessoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accessoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StandardAdRecommendationCell.bottomMargin),

            iconImageView.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: StandardAdRecommendationCell.iconSize),

            imageDescriptionBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            imageDescriptionBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            imageDescriptionBackgroundView.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.imageDescriptionHeight),
            imageDescriptionBackgroundView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: -.spacingS),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXS),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXS),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor)
        ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelLoading()
        imageView.image = nil
        imageView.alpha = 0.0
        imageView.contentMode = .scaleAspectFill
        imageContentView.backgroundColor = loadingColor
        iconImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        accessoryLabel.text = ""
        imageTextLabel.text = ""
        containerView.accessibilityLabel = ""
        favoriteButton.accessibilityLabel = ""
        favoriteButton.setImage(nil, for: .normal)
        logoImageView.cancelLoading()
        logoImageView.image = nil
        iconImageView.isHidden = true
        imageTextLabel.isHidden = true
        imageDescriptionBackgroundView.isHidden = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageContentView.layer.borderColor = .imageBorder
    }

    // MARK: - Dependency injection

    public func configure(with model: StandardAdRecommendationViewModel?, atIndex index: Int) {
        self.model = model
        self.index = index

        iconImageView.image = model?.iconImage?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = model?.title
        subtitleLabel.text = model?.subtitle
        accessoryLabel.text = model?.accessory
        imageTextLabel.text = model?.imageText
        containerView.accessibilityLabel = model?.accessibilityLabel
        favoriteButton.accessibilityLabel = model?.favoriteButtonAccessibilityLabel
        isFavorite = model?.isFavorite ?? false

        ribbonView.style = .sponsored
        ribbonView.title = model?.sponsoredAdData?.ribbonTitle ?? ""
        ribbonView.isHidden = ribbonView.title.isEmpty

        NSLayoutConstraint.deactivate([subtitleToImageConstraint, subtitleToRibbonConstraint])
        NSLayoutConstraint.activate([ribbonView.title.isEmpty ? subtitleToImageConstraint : subtitleToRibbonConstraint])

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[index % 4]
        loadingColor = color

        if let model = model {
            if !model.scaleImageToFillView {
                imageView.contentMode = .scaleAspectFit
                imageContentView.backgroundColor = .white
            }
        }

        iconImageView.isHidden = iconImageView.image == nil
        imageTextLabel.isHidden = imageTextLabel.text == nil
        imageDescriptionBackgroundView.isHidden = model?.hideImageOverlay ?? false
    }

    public var isFavorite = false {
        didSet {
            favoriteButton.isToggled = isFavorite
        }
    }

    // MARK: - Public

    /// Height in cell that is not image
    private static var nonImageHeight: CGFloat {
        return subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + bottomMargin
    }

    /// Height in cell that is not image including the height of accessory label
    private static var nonImageWithAccessoryHeight: CGFloat {
        return subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + accessoryHeight + bottomMargin
    }

    public static func height(for model: StandardAdRecommendationViewModel, width: CGFloat) -> CGFloat {
        let imageRatio = model.imageSize.height / model.imageSize.width
        let clippedImageRatio = min(max(imageRatio, StandardAdRecommendationCell.minImageAspectRatio), StandardAdRecommendationCell.maxImageAspectRatio)
        let imageHeight = width * clippedImageRatio
        var contentHeight = subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + bottomMargin

        if model.accessory != nil {
            contentHeight += accessoryHeight
        }

        if model.sponsoredAdData?.ribbonTitle != nil {
            contentHeight += ribbonTopMargin + ribbonHeight
        }

        return imageHeight + contentHeight
    }

    public func loadImage() {
        if imageView.image == nil {
            if let imagePath = model?.imagePath {
                imageView.loadImage(for: imagePath, imageWidth: frame.size.width, fallbackImage: defaultImage)
            } else {
                setDefaultImage()
            }
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

    // MARK: - Private

    private func setDefaultImage() {
        imageView.image = defaultImage
        self.imageView.alpha = 1.0
    }

    private func setImage(_ image: UIImage?, animated: Bool) {
        imageView.image = image

        let performViewChanges = { [weak self] in
            self?.imageView.alpha = 1.0
            self?.imageContentView.backgroundColor = .clear
        }

        if animated {
            imageView.alpha = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: performViewChanges)
        } else {
            performViewChanges()
        }
    }

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }

    @objc private func handleFavoriteButtonTap(_ button: UIButton) {
        delegate?.adRecommendationCell(self, didTapFavoriteButton: button)
    }
}
