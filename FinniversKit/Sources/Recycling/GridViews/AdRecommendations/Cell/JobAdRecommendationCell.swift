//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class JobAdRecommendationCell: UICollectionViewCell, AdRecommendationCell {

    public var model: JobAdRecommendationViewModel?

    public weak var delegate: AdRecommendationCellDelegate?

    public weak var imageDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = imageDataSource
        }
    }

    public var index: Int?

    public var isFavorite: Bool = false {
        didSet {
            favoriteButton.isToggled = isFavorite
        }
    }

    private let loadingColors: [UIColor] = [.yellow100, .red100]

    private var loadingColor: UIColor = .clear {
        didSet {
            imageViewContainer.backgroundColor = loadingColor
        }
    }

    private lazy var defaultImage: UIImage = UIImage(named: .noImage)

    /// Extra container for accessibility issues. The cell should have "all content" and favoriteButton as accessibilty elements but it get confused if favoriteButton is a subview of the other accessibility element (so contentView can not be one of the accessibility elements
    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        return view
    }()

    private lazy var imageViewContainer = UIView(withAutoLayout: true)

    private lazy var imageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.delegate = self
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var ribbonView: RibbonView = {
        let view = RibbonView(withAutoLayout: true)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFavoriteButtonTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var metadataContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgTertiary
        return view
    }()

    private lazy var titleLabel: Label = {
        let view = Label(style: .body, withAutoLayout: true)
        view.numberOfLines = 0
        return view
    }()

    private lazy var companyLabel: Label = {
        let view = Label(style: .detail, withAutoLayout: false)
        view.numberOfLines = 0
        return view
    }()

    private lazy var locationAndTimeLabel: Label = {
        let view = Label(style: .detail, withAutoLayout: false)
        view.numberOfLines = 0
        view.textAlignment = .right
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .bottom
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        ribbonView.isHidden = true
        ribbonView.title = ""
        isFavorite = false
        imageView.image = nil
        imageView.alpha = 0.0
        imageViewContainer.alpha = 0.0
        titleLabel.text = nil
        companyLabel.text = nil
        locationAndTimeLabel.text = nil

        containerView.accessibilityLabel = nil
        favoriteButton.accessibilityLabel = nil
    }

    private func setup() {
        containerView.isAccessibilityElement = true
        accessibilityElements = [containerView, favoriteButton]
        containerView.accessibilityTraits = .button

        contentView.layer.cornerRadius = .spacingS
        contentView.layer.borderWidth = 1

        contentView.addSubview(containerView)
        containerView.addSubview(imageViewContainer)
        containerView.addSubview(metadataContainer)
        containerView.addSubview(ribbonView)
        contentView.addSubview(favoriteButton)

        imageViewContainer.addSubview(imageView)

        let metadataContainerLayoutGuide = UILayoutGuide()
        metadataContainer.addLayoutGuide(metadataContainerLayoutGuide)
        metadataContainer.addSubview(titleLabel)
        metadataContainer.addSubview(stackView)

        stackView.addArrangedSubviews([
            companyLabel,
            locationAndTimeLabel
        ])

        NSLayoutConstraint.activate([
            imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: metadataContainer.topAnchor),

            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor, constant: .spacingS),
            imageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor, constant: -.spacingS, priority: .required - 1),
            imageView.widthAnchor.constraint(equalTo: imageViewContainer.widthAnchor, multiplier: JobAdRecommendationCell.imageWidthMultiplier),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: JobAdRecommendationCell.imageHeightMultiplier),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXS),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXS),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor),

            ribbonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            ribbonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),

            metadataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            metadataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            metadataContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            metadataContainerLayoutGuide.topAnchor.constraint(equalTo: metadataContainer.topAnchor, constant: .spacingS),
            metadataContainerLayoutGuide.leadingAnchor.constraint(equalTo: metadataContainer.leadingAnchor, constant: .spacingS),
            metadataContainerLayoutGuide.trailingAnchor.constraint(equalTo: metadataContainer.trailingAnchor, constant: -.spacingS),
            metadataContainerLayoutGuide.bottomAnchor.constraint(equalTo: metadataContainer.bottomAnchor, constant: -.spacingS),

            titleLabel.leadingAnchor.constraint(equalTo: metadataContainerLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: metadataContainerLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: metadataContainerLayoutGuide.topAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            stackView.leadingAnchor.constraint(equalTo: metadataContainerLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: metadataContainerLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: metadataContainerLayoutGuide.bottomAnchor),
        ])
    }

    public override func layoutSubviews() {
        contentView.layer.borderColor = .imageBorder

        super.layoutSubviews()
    }

    public func loadImage() {
        if let imagePath = model?.imagePath {
            imageView.loadImage(for: imagePath, imageWidth: frame.size.width, loadingColor: loadingColor, fallbackImage: defaultImage)
        } else {
            imageView.image = defaultImage
            imageView.alpha = 1
            imageViewContainer.alpha = 1
        }
    }

    @objc private func handleFavoriteButtonTap(_ button: UIButton) {
        delegate?.adRecommendationCell(self, didTapFavoriteButton: button)
    }
}

// MARK: - AdRecommendationConfigurable
extension JobAdRecommendationCell: AdRecommendationConfigurable {
    public func configure(with model: JobAdRecommendationViewModel?, atIndex index: Int) {
        self.model = model
        self.index = index

        loadingColor = loadingColors[index % loadingColors.count]

        containerView.accessibilityLabel = model?.accessibilityLabel
        favoriteButton.accessibilityLabel = model?.favoriteButtonAccessibilityLabel

        titleLabel.text = model?.title
        companyLabel.text = model?.company
        locationAndTimeLabel.text = model?.locationAndPublishedRelative
        isFavorite = model?.isFavorite ?? false

        if let ribbonViewModel = model?.ribbonOverlayModel {
            ribbonView.configure(with: ribbonViewModel)
            ribbonView.isHidden = false
        }
    }
}

// MARK: - Static methods
public extension JobAdRecommendationCell {
    static let imageWidthMultiplier: CGFloat = 0.5
    static let imageHeightMultiplier: CGFloat = 0.85

    static func height(for model: JobAdRecommendationViewModel, width: CGFloat) -> CGFloat {
        let titleLabel = Label(style: .body)
        titleLabel.numberOfLines = 0
        titleLabel.text = model.title

        let detailLabel = Label(style: .detail)
        detailLabel.numberOfLines = 0
        detailLabel.text = model.company.count >= model.locationAndPublishedRelative.count
            ? model.company
            : model.locationAndPublishedRelative

        var imageHeight = (width * imageWidthMultiplier) * imageHeightMultiplier
        imageHeight += .spacingS * 2 // Vertical padding of image

        let horizontalContainerPadding = .spacingS * 2

        var height: CGFloat = .spacingS * 2 // Vertical padding of container
        height += imageHeight
        height += titleLabel.sizeThatFits(CGSize(width: width - horizontalContainerPadding, height: CGFloat.greatestFiniteMagnitude)).height
        height += .spacingS // Vertical padding between labels
        height += detailLabel.sizeThatFits(CGSize(width: (width - horizontalContainerPadding) / 2, height: CGFloat.greatestFiniteMagnitude)).height

        return ceil(height)
    }
}

// MARK: - RemoteImageViewDelegate
extension JobAdRecommendationCell: RemoteImageViewDelegate {
    public func remoteImageViewDidSetImage(_ view: RemoteImageView) {
        imageViewContainer.backgroundColor = .clear
        imageViewContainer.alpha = 1.0
    }
}
