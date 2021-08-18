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

    private lazy var imageDescriptionView: UIVisualEffectView = {
        let view = UIVisualEffectView(withAutoLayout: true)
        if #available(iOS 13.0, *) {
            view.effect = UIBlurEffect(style: .systemThinMaterialDark)
        } else {
            view.effect = nil
            view.backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.8)
        }
        view.alpha = 1.0
        view.layer.cornerRadius = StandardAdRecommendationCell.imageDescriptionHeight / 2
        view.clipsToBounds = true
        return view
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
    
    private var imageDescriptionViewTrailingConstraint: NSLayoutConstraint?

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

        contentView.addSubview(imageContentView)
        imageContentView.addSubview(imageView)
        imageContentView.addSubview(imageDescriptionView)
        imageView.fillInSuperview()

        contentView.addSubview(ribbonView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(accessoryLabel)

        imageDescriptionView.contentView.addSubview(iconImageView)
        imageDescriptionView.contentView.addSubview(imageTextLabel)

        backgroundColor = .bgPrimary

        let imageHeightMinimumConstraint = imageContentView.heightAnchor.constraint(equalTo: imageContentView.widthAnchor, multiplier: StandardAdRecommendationCell.minImageAspectRatio)
        let imageHeightMaximumConstraint = imageContentView.heightAnchor.constraint(lessThanOrEqualTo: imageContentView.widthAnchor, multiplier: StandardAdRecommendationCell.maxImageAspectRatio)

        imageHeightMinimumConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageHeightMinimumConstraint,
            imageHeightMaximumConstraint,

            ribbonView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: StandardAdRecommendationCell.ribbonTopMargin),
            ribbonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            logoImageView.topAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: .spacingS),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),

            subtitleToImageConstraint,
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.subtitleHeight),

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: StandardAdRecommendationCell.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.titleHeight),

            accessoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            accessoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accessoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StandardAdRecommendationCell.bottomMargin),

            iconImageView.leadingAnchor.constraint(equalTo: imageDescriptionView.leadingAnchor, constant: StandardAdRecommendationCell.margin),
            iconImageView.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: StandardAdRecommendationCell.iconSize),
            iconImageView.centerYAnchor.constraint(equalTo: imageDescriptionView.centerYAnchor),

            imageTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: StandardAdRecommendationCell.margin),
            imageTextLabel.centerYAnchor.constraint(equalTo: imageDescriptionView.centerYAnchor),

            imageDescriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            imageDescriptionView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            imageDescriptionView.heightAnchor.constraint(equalToConstant: StandardAdRecommendationCell.imageDescriptionHeight),
            imageDescriptionView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor, constant: -.spacingS),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXS),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXS),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor)
        ])
        
        // Storing a reference to the trailing constraint for the imageDescriotionView so that we can update the icon alignment when needed
        imageDescriptionViewTrailingConstraint = imageDescriptionView.trailingAnchor.constraint(equalTo: imageTextLabel.trailingAnchor, constant: StandardAdRecommendationCell.margin)
        imageDescriptionViewTrailingConstraint?.isActive = true
    }
    
    

    // MARK: - Superclass Overrides

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
        accessibilityLabel = ""
        favoriteButton.accessibilityLabel = ""
        favoriteButton.setImage(nil, for: .normal)
        imageView.cancelLoading()
        logoImageView.cancelLoading()
        logoImageView.image = nil
        showImageDescriptionView = true
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
        accessibilityLabel = model?.accessibilityLabel
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
        
        // update imageDescriptionView visibility
        if let imageText = model?.imageText {
            centerIconInContainer(imageText.trimmingCharacters(in: .whitespaces).isEmpty)
        } else {
            centerIconInContainer(true)
        }
    }

    public var isFavorite = false {
        didSet {
            favoriteButton.isToggled = isFavorite
        }
    }

    public var showImageDescriptionView = true {
        didSet {
            imageDescriptionView.isHidden = !showImageDescriptionView
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
    
    private func centerIconInContainer(_ shouldCenter: Bool) {
        guard let trailingConstraint = self.imageDescriptionViewTrailingConstraint else { return }
        trailingConstraint.constant = shouldCenter ? 0 : StandardAdRecommendationCell.margin
    }

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }

    @objc private func handleFavoriteButtonTap(_ button: UIButton) {
        delegate?.adRecommendationCell(self, didTapFavoriteButton: button)
    }
}
