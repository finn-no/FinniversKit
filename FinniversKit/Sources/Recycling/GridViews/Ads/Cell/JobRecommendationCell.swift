//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class JobRecommendationCell: UICollectionViewCell, AdRecommendationCell {

    public var model: JobRecommendationModel?

    public weak var delegate: AdRecommendationCellDelegate?

    public weak var imageDataSource: RemoteImageViewDataSource? {
        didSet {
            logoView.dataSource = imageDataSource
        }
    }

    public var index: Int?

    public var isFavorite: Bool = false {
        didSet {
            favoriteButton.isToggled = isFavorite
        }
    }

    private lazy var logoView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
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
        view.backgroundColor = .marble
        return view
    }()

    private lazy var titleLabel: Label = {
        let view = Label(style: .body, withAutoLayout: true)
        view.numberOfLines = 2
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
        isFavorite = false
        logoView.image = nil
    }

    private func setup() {
        isAccessibilityElement = true

        let layoutGuide = UILayoutGuide()

        contentView.layer.cornerRadius = .spacingS
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = .imageBorder

        contentView.addSubview(logoView)
        contentView.addSubview(metadataContainer)
        contentView.addSubview(ribbonView)
        contentView.addSubview(favoriteButton)

        metadataContainer.addLayoutGuide(layoutGuide)
        metadataContainer.addSubview(titleLabel)
        metadataContainer.addSubview(stackView)

        stackView.addArrangedSubviews([
            companyLabel,
            locationAndTimeLabel
        ])

        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            logoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.50),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 0.85),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXS),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXS),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor),

            ribbonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            ribbonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),

            metadataContainer.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: .spacingS),
            metadataContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            metadataContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            metadataContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            layoutGuide.topAnchor.constraint(equalTo: metadataContainer.topAnchor, constant: .spacingS),
            layoutGuide.leadingAnchor.constraint(equalTo: metadataContainer.leadingAnchor, constant: .spacingS),
            layoutGuide.trailingAnchor.constraint(equalTo: metadataContainer.trailingAnchor, constant: -.spacingS),
            layoutGuide.bottomAnchor.constraint(equalTo: metadataContainer.bottomAnchor, constant: -.spacingS),

            titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            stackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
        ])
    }

    public func loadImage() {
        if let imagePath = model?.imagePath {
            logoView.loadImage(for: imagePath, imageWidth: frame.size.width)
        }
    }

    @objc private func handleFavoriteButtonTap(_ button: UIButton) {
        delegate?.adRecommendationCell(self, didTapFavoriteButton: button)
    }
}

extension JobRecommendationCell: AdRecommendationConfigurable {
    public func configure(with model: JobRecommendationModel?, atIndex index: Int) {
        self.model = model
        self.index = index

        accessibilityLabel = model?.accessibilityLabel
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

public extension JobRecommendationCell {
    static func height(for model: JobRecommendationModel, width: CGFloat) -> CGFloat {
        var imageHeight = (width * 0.5) * 0.85
        imageHeight += .spacingS * 2

        let titleLabel = Label(style: .body)
        titleLabel.numberOfLines = 2
        titleLabel.text = model.title

        let detailLabel = Label(style: .detail)
        detailLabel.numberOfLines = 0
        detailLabel.text = model.company.count >= model.locationAndPublishedRelative.count
            ? model.company
            : model.locationAndPublishedRelative

        var height: CGFloat = .spacingS * 2
        height += imageHeight
        height += titleLabel.sizeThatFits(CGSize(width: width - .spacingS * 2, height: CGFloat.greatestFiniteMagnitude)).height
        height += .spacingS
        height += detailLabel.sizeThatFits(CGSize(width: (width / 2) - .spacingS * 2, height: CGFloat.greatestFiniteMagnitude)).height

        return ceil(height)
    }
}
