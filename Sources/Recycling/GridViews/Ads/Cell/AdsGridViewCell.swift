//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdsGridViewCellDataSource: AnyObject {
    func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, cachedImageForModel model: AdsGridViewModel) -> UIImage?
    func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((AdsGridViewModel, UIImage?) -> Void))
    func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat)
}

public protocol AdsGridViewCellDelegate: AnyObject {
    func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, didSelectFavoriteButton button: UIButton)
}

public class AdsGridViewCell: UICollectionViewCell {
    // MARK: - Internal properties

    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let bottomMargin: CGFloat = 15.0
    private static let subtitleHeight: CGFloat = 17.0
    private static let subtitleTopMargin: CGFloat = 6.0
    private static let accessoryHeight: CGFloat = 14.0
    private static let margin: CGFloat = 8.0
    private static let cornerRadius: CGFloat = 8.0
    private static let imageDescriptionHeight: CGFloat = 35.0
    private static let iconSize: CGFloat = 23.0

    private lazy var imageBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = AdsGridViewCell.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .bgPrimary
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var accessoryLabel: Label = {
        let label = Label(style: .detailStrong)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var imageDescriptionView: UIView = {
        let view = UILabel(withAutoLayout: true)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 1.0
        view.layer.cornerRadius = AdsGridViewCell.cornerRadius
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var imageTextLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleFavoriteButtonTap(_:)), for: .touchUpInside)
        return button
    }()

    private var model: AdsGridViewModel?

    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor? {
        didSet {
            imageBackgroundView.backgroundColor = loadingColor
        }
    }

    /// A data source for the loading of the image
    public weak var dataSource: AdsGridViewCellDataSource?

    /// A delegate for actions triggered from the cell
    public weak var delegate: AdsGridViewCellDelegate?

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

        addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(imageView)
        imageView.fillInSuperview()

        addSubview(subtitleLabel)
        addSubview(titleLabel)
        addSubview(imageDescriptionView)
        addSubview(favoriteButton)
        addSubview(accessoryLabel)

        imageDescriptionView.addSubview(iconImageView)
        imageDescriptionView.addSubview(imageTextLabel)

        backgroundColor = .bgPrimary

        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            imageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: AdsGridViewCell.subtitleTopMargin),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: AdsGridViewCell.subtitleHeight),

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: AdsGridViewCell.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: AdsGridViewCell.titleHeight),

            accessoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            accessoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AdsGridViewCell.bottomMargin),

            iconImageView.leadingAnchor.constraint(equalTo: imageDescriptionView.leadingAnchor, constant: AdsGridViewCell.margin),
            iconImageView.heightAnchor.constraint(equalToConstant: AdsGridViewCell.iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: AdsGridViewCell.iconSize),
            iconImageView.centerYAnchor.constraint(equalTo: imageDescriptionView.centerYAnchor),

            imageTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: AdsGridViewCell.margin),
            imageTextLabel.centerYAnchor.constraint(equalTo: imageDescriptionView.centerYAnchor),

            imageDescriptionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageDescriptionView.trailingAnchor.constraint(equalTo: imageTextLabel.trailingAnchor, constant: AdsGridViewCell.margin),
            imageDescriptionView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            imageDescriptionView.heightAnchor.constraint(equalToConstant: AdsGridViewCell.imageDescriptionHeight),
            imageDescriptionView.bottomAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor),

            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: .smallSpacing),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor)
            ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.alpha = 0.0
        imageBackgroundView.backgroundColor = loadingColor
        iconImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        accessoryLabel.text = ""
        imageTextLabel.text = ""
        accessibilityLabel = ""
        favoriteButton.accessibilityLabel = ""
        favoriteButton.setImage(nil, for: .normal)

        if let model = model {
            dataSource?.adsGridViewCell(self, cancelLoadingImageForModel: model, imageWidth: imageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    public func configure(with model: AdsGridViewModel?, atIndex index: Int) {
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

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[index % 4]
        loadingColor = color
    }

    public var isFavorite = false {
        didSet {
            favoriteButton.isFavorite = isFavorite
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

    public static func height(for model: AdsGridViewModel, width: CGFloat) -> CGFloat {
        let imageRatio = model.imageSize.height / model.imageSize.width
        let imageHeight = width * imageRatio

        if model.accessory != nil {
            return imageHeight + nonImageWithAccessoryHeight
        } else {
            return imageHeight + nonImageHeight
        }
    }

    public func loadImage() {
        guard imageView.image == nil else {
            return
        }

        guard let viewModel = model, let dataSource = dataSource, viewModel.imagePath != nil else {
            setDefaultImage()
            return
        }

        if let cachedImage = dataSource.adsGridViewCell(self, cachedImageForModel: viewModel) {
            setImage(cachedImage, animated: false)
        } else {
            dataSource.adsGridViewCell(self, loadImageForModel: viewModel, imageWidth: frame.size.width) { [weak self] (fetchedModel, image) in
                guard let model = self?.model else { return }
                guard fetchedModel.imagePath == model.imagePath else { return }

                if let displayImage = image {
                    self?.setImage(displayImage, animated: true)
                } else {
                    self?.setDefaultImage()
                }
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
            self?.imageBackgroundView.backgroundColor = .clear
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
        delegate?.adsGridViewCell(self, didSelectFavoriteButton: button)
    }
}

// MARK: - Private types

private final class FavoriteButton: UIButton {
    var isFavorite = false {
        didSet {
            let image = isFavorite ? UIImage(named: .favouriteAddedImg) : UIImage(named: .favouriteAddImg)
            setImage(image, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsImageWhenHighlighted = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.8 : 1
        }
    }
}
