//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol NotificationsListViewCellDataSource: AnyObject {
    func notificationsListViewCell(_ notificationsListViewCell: NotificationsListViewCell, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func notificationsListViewCell(_ notificationsListViewCell: NotificationsListViewCell, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat)
}

public class NotificationsListViewCell: UITableViewCell {
    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?

    /// A data source for the loading of the image
    public weak var dataSource: NotificationsListViewCellDataSource?

    // MARK: - Internal properties

    private static let cornerRadius: CGFloat = 2.0
    private static let imageSize: CGFloat = 74.0

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = NotificationsListViewCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 2
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .detail)
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(adImageView)
        addSubview(detailLabel)
        addSubview(titleLabel)
        addSubview(priceLabel)

        backgroundColor = .bgPrimary

        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            adImageView.heightAnchor.constraint(equalToConstant: NotificationsListViewCell.imageSize),
            adImageView.widthAnchor.constraint(equalToConstant: NotificationsListViewCell.imageSize),

            detailLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            titleLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .smallSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallSpacing),
            priceLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adImageView.image = nil
        detailLabel.text = nil
        titleLabel.text = nil
        priceLabel.text = nil
        accessibilityLabel = ""

        if let model = model {
            dataSource?.notificationsListViewCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    /// The model contains data used to populate the view.
    public var model: NotificationsListViewModel? {
        didSet {
            if let model = model {
                detailLabel.text = model.detail
                titleLabel.text = model.title
                priceLabel.text = model.price
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

    private func loadImage(model: NotificationsListViewModel) {
        guard let dataSource = dataSource, model.imagePath != nil else {
            loadingColor = .clear
            adImageView.image = defaultImage
            return
        }

        adImageView.backgroundColor = loadingColor

        dataSource.notificationsListViewCell(self, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear

            if let image = image {
                self?.adImageView.image = image
            } else {
                self?.adImageView.image = self?.defaultImage
            }
        }
    }

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }
}
