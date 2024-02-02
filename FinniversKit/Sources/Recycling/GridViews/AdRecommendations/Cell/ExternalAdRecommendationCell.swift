import Foundation

public class ExternalAdRecommendationCell: UICollectionViewCell, AdRecommendationCell, AdRecommendationConfigurable {
    // MARK: - External properties

    /// A data source for the loading of the image
    public weak var imageDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = imageDataSource
        }
    }

    /// A delegate for actions triggered from the cell
    public weak var delegate: AdRecommendationCellDelegate?

    /// Optional index of the cell
    public var index: Int?


    //This variable is included to conform to protocol 'AdRecommendationCell',
    //but currently there is no favorite button in the external ad cell
    public var isFavorite = false

    // MARK: - Internal properties

    private static let titleHeight: CGFloat = 20.0
    private static let titleHeightTwoLines: CGFloat = 40.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let bottomMargin: CGFloat = 15.0
    private static let subtitleHeight: CGFloat = 17.0
    private static let ribbonTopMargin: CGFloat = 6.0
    private static let ribbonHeight: CGFloat = 19.0
    private static let subtitleTopMargin: CGFloat = 6.0
    private static let accessoryHeight: CGFloat = 14.0
    private static let margin: CGFloat = 8.0
    private static let cornerRadius: CGFloat = 8.0
    private static let minImageAspectRatio: CGFloat = 0.75
    private static let maxImageAspectRatio: CGFloat = 1.5

    private let loadingColor: UIColor = .bgTertiary

    /// Extra container for accessibility issues. The cell should have "all content" and favoriteButton (if added) as accessibilty elements but it get confused if favoriteButton is a subview of the other accessibility element (so contentView can not be one of the accessibility elements
    private lazy var containerView = UIView(withAutoLayout: true)

    private lazy var imageContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = ExternalAdRecommendationCell.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var ribbonView = RibbonView(withAutoLayout: true)

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview).withTintColor(.iconSecondary)
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, numberOfLines: 3, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, textColor: .textSecondary, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subtitleToImageConstraint = subtitleLabel.topAnchor.constraint(
        equalTo: imageContentView.bottomAnchor,
        constant: ExternalAdRecommendationCell.subtitleTopMargin
    )

    private lazy var subtitleToRibbonConstraint = subtitleLabel.topAnchor.constraint(
        equalTo: ribbonView.bottomAnchor,
        constant: ExternalAdRecommendationCell.subtitleTopMargin
    )

    private lazy var titleToRibbonConstraint = titleLabel.topAnchor.constraint(
        equalTo: ribbonView.bottomAnchor,
        constant: ExternalAdRecommendationCell.titleTopMargin
    )

    private lazy var shortTitleHeightConstraint =  titleLabel.heightAnchor.constraint(equalToConstant: ExternalAdRecommendationCell.titleHeight*accessibilityMultiplier)

    private lazy var longTitleHeightConstraint =  titleLabel.heightAnchor.constraint(equalToConstant: ExternalAdRecommendationCell.titleHeightTwoLines*accessibilityMultiplier)

    var accessibilityMultiplier: CGFloat {
        if Config.isDynamicTypeEnabled {
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
        }
        return 1.0
    }

    private var model: ExternalAdRecommendationViewModel?

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
        containerView.isAccessibilityElement = true
        accessibilityElements = [containerView]
        shouldGroupAccessibilityChildren = true
        containerView.accessibilityTraits.insert(.link)
        imageView.accessibilityElementsHidden = true

        containerView.addSubview(imageContentView)
        imageContentView.addSubview(imageView)
        imageView.fillInSuperview()

        contentView.addSubview(containerView)
        containerView.addSubview(ribbonView)
        containerView.addSubview(externalLinkImageView)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(titleLabel)

        backgroundColor = .clear

        let imageHeightMinimumConstraint = imageContentView.heightAnchor.constraint(equalTo: imageContentView.widthAnchor, multiplier: ExternalAdRecommendationCell.minImageAspectRatio)
        let imageHeightMaximumConstraint = imageContentView.heightAnchor.constraint(lessThanOrEqualTo: imageContentView.widthAnchor, multiplier: ExternalAdRecommendationCell.maxImageAspectRatio)

        imageHeightMinimumConstraint.priority = .defaultHigh

        containerView.fillInSuperview()

        NSLayoutConstraint.activate([
            imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageHeightMinimumConstraint,
            imageHeightMaximumConstraint,

            ribbonView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: ExternalAdRecommendationCell.ribbonTopMargin),
            ribbonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ribbonView.heightAnchor.constraint(equalToConstant: ExternalAdRecommendationCell.ribbonHeight * accessibilityMultiplier),

            externalLinkImageView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: ExternalAdRecommendationCell.ribbonTopMargin),
            externalLinkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            externalLinkImageView.widthAnchor.constraint(equalToConstant: .spacingM),
            externalLinkImageView.heightAnchor.constraint(equalToConstant: .spacingM),

            subtitleToImageConstraint,
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: ExternalAdRecommendationCell.subtitleHeight*accessibilityMultiplier),

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: ExternalAdRecommendationCell.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.alpha = 0.0
        imageView.contentMode = .scaleAspectFill
        imageContentView.backgroundColor = loadingColor
        titleLabel.text = ""
        subtitleLabel.text = ""
        containerView.accessibilityLabel = ""
        NSLayoutConstraint.deactivate([longTitleHeightConstraint])
        NSLayoutConstraint.activate([shortTitleHeightConstraint])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageContentView.layer.borderColor = .imageBorder
    }

    // MARK: - Dependency injection

    public func configure(with model: ExternalAdRecommendationViewModel?, atIndex index: Int) {
        self.model = model
        self.index = index

        titleLabel.text = model?.title
        if let height = model?.title.height(withConstrainedWidth: contentView.frame.width, font: titleLabel.font), height > ExternalAdRecommendationCell.titleHeight {
            NSLayoutConstraint.deactivate([shortTitleHeightConstraint])
            NSLayoutConstraint.activate([longTitleHeightConstraint])
        }

        if let subtitle = model?.subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            NSLayoutConstraint.activate([subtitleToImageConstraint])
        } else {
            titleToRibbonConstraint.isActive = true
        }

        containerView.accessibilityLabel = model?.accessibilityLabel
        ribbonView.style = model?.ribbonViewModel?.style ?? .sponsored
        ribbonView.title = model?.ribbonViewModel?.title ?? ""
        ribbonView.isHidden = ribbonView.title.isEmpty

        NSLayoutConstraint.activate([ribbonView.title.isEmpty ? titleToRibbonConstraint : subtitleToRibbonConstraint])

        imageContentView.backgroundColor = loadingColor

        if let model = model {
            if !model.scaleImageToFillView {
                imageView.contentMode = .scaleAspectFit
                imageContentView.backgroundColor = .white
            }
        }
    }

    // MARK: - Public

    public static func height(for model: ExternalAdRecommendationViewModel, width: CGFloat) -> CGFloat {
        let titleHeight = model.title.height(withConstrainedWidth: width, font: .body)
        let imageRatio = model.imageSize.height / model.imageSize.width
        let clippedImageRatio = min(max(imageRatio, ExternalAdRecommendationCell.minImageAspectRatio), ExternalAdRecommendationCell.maxImageAspectRatio)
        let imageHeight = width * clippedImageRatio
        let contentHeight = subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + bottomMargin

        return imageHeight + contentHeight
    }

    public func loadImage() {
        if let imagePath = model?.imagePath {
            imageView.loadImage(for: imagePath, imageWidth: frame.size.width, fallbackImage: defaultImage)
        } else {
            setDefaultImage()
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

}
