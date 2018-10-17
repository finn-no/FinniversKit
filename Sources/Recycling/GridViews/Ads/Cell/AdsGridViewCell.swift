//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdsGridViewCellDataSource {
    func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func adsGridViewCell(_ adsGridViewCell: AdsGridViewCell, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat)
}

public class AdsGridViewCell: UICollectionViewCell {
    // MARK: - Internal properties

    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = 17.0
    private static let subtitleHeight: CGFloat = 17.0
    private static let subtitleTopMargin: CGFloat = 6.0
    private static let margin: CGFloat = 8.0
    private static let cornerRadius: CGFloat = 8.0
    private static let imageDescriptionHeight: CGFloat = 35.0
    private static let iconSize: CGFloat = 23.0

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = AdsGridViewCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .milk
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
        label.textColor = .stone
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var imageDescriptionView: UIView = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 1.0
        view.layer.cornerRadius = AdsGridViewCell.cornerRadius
        view.layer.masksToBounds = true

        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }

        return view
    }()

    private lazy var imageTextLabel: Label = {
        let label = Label(style: .title4)
        label.textColor = .milk
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?

    /// A data source for the loading of the image
    public var dataSource: AdsGridViewCellDataSource?

    /// Height in cell that is not image
    public static var nonImageHeight: CGFloat {
        return subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + titleBottomMargin
    }

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

        addSubview(imageView)
        addSubview(subtitleLabel)
        addSubview(titleLabel)
        addSubview(imageDescriptionView)

        imageDescriptionView.addSubview(iconImageView)
        imageDescriptionView.addSubview(imageTextLabel)

        backgroundColor = .milk

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: AdsGridViewCell.subtitleTopMargin),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: AdsGridViewCell.subtitleHeight),

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: AdsGridViewCell.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: AdsGridViewCell.titleHeight),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AdsGridViewCell.titleBottomMargin),

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
            imageDescriptionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        iconImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        imageTextLabel.text = ""
        accessibilityLabel = ""

        if let model = model {
            dataSource?.adsGridViewCell(self, cancelLoadingImageForModel: model, imageWidth: imageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    /// The model contains data used to populate the view.
    public var model: AdsGridViewModel? {
        didSet {
            if let model = model {
                iconImageView.image = model.iconImage?.withRenderingMode(.alwaysTemplate)
                titleLabel.text = model.title
                subtitleLabel.text = model.subtitle
                imageTextLabel.text = model.imageText
                accessibilityLabel = model.accessibilityLabel
            }
        }
    }

    // MARK: - Public

    /// Loads the image for the `model` if imagePath is set
    public func loadImage() {
        if let model = model {
            loadImage(model: model)
        }
    }

    // MARK: - Private

    private func loadImage(model: AdsGridViewModel) {
        guard let dataSource = dataSource, model.imagePath != nil else {
            loadingColor = .clear
            imageView.image = defaultImage
            return
        }

        imageView.backgroundColor = loadingColor

        dataSource.adsGridViewCell(self, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.imageView.backgroundColor = .clear

            if let image = image {
                self?.imageView.image = image
            } else {
                self?.imageView.image = self?.defaultImage
            }
        }
    }

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }
}
