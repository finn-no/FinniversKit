//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public enum UserAdStatus: String {
    case draft = "Påbegynt"
    case active = "Aktiv"
    case inactive = "Inaktiv"
    case expired = "Utløpt"
    case sold = "Solgt"
    case unknown = "Ukjent"
}

public protocol UserAdsListViewCellDataSource: class {
    func userAdsListViewCellShouldDisplayAsInactive(_ userAdsListViewCell: UserAdsListViewCell) -> Bool
    func userAdsListViewCell(_ userAdsListViewCell: UserAdsListViewCell, loadImageForModel model: UserAdsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func userAdsListViewCell(_ userAdsListViewCell: UserAdsListViewCell, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat)
}

public class UserAdsListViewCell: UITableViewCell {
    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.

    public var loadingColor: UIColor?

    /// A data source for the loading of the image

    public weak var dataSource: UserAdsListViewCellDataSource?

    // MARK: - Internal properties

    private static let cornerRadius: CGFloat = 12
    private static let activeImageSize: CGFloat = 100
    private static let inactiveImageSize: CGFloat = 56

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }

    private lazy var userAdStatus: UserAdStatus = .unknown

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = UserAdsListViewCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var priceLabel: Label? = {
        let label = Label(style: .title5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .stone
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var ribbonView: RibbonView? = nil

    // MARK: - Setup

    private func setupView() {
        isAccessibilityElement = true
        backgroundColor = .milk
        accessoryType = .disclosureIndicator
        selectionStyle = .none

        addSubview(adImageView)
        addSubview(titleLabel)

        if dataSource?.userAdsListViewCellShouldDisplayAsInactive(self) ?? false {
            separatorInset = UIEdgeInsets(top: 0, left: (UserAdsListViewCell.inactiveImageSize + .mediumSpacing), bottom: 0, right: 0)

            NSLayoutConstraint.activate([
                adImageView.heightAnchor.constraint(equalToConstant: UserAdsListViewCell.inactiveImageSize),
                adImageView.widthAnchor.constraint(equalToConstant: UserAdsListViewCell.inactiveImageSize),
                adImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
                adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),

                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: ribbonView?.leadingAnchor ?? trailingAnchor)
            ])
        } else {
            separatorInset = UIEdgeInsets(top: 0, left: (UserAdsListViewCell.activeImageSize + .mediumSpacing), bottom: 0, right: 0)
            addSubview(detailLabel)

            NSLayoutConstraint.activate([
                adImageView.heightAnchor.constraint(equalToConstant: UserAdsListViewCell.activeImageSize),
                adImageView.widthAnchor.constraint(equalToConstant: UserAdsListViewCell.activeImageSize),
                adImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
                adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),

                titleLabel.bottomAnchor.constraint(equalTo: (ribbonView?.topAnchor ?? detailLabel.topAnchor), constant: -.smallSpacing),
                titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

                detailLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            ])

            // If price is not provided then the detailLabel should be centered with the ribbonView
            if model?.price == nil {
                NSLayoutConstraint.activate([
                    detailLabel.centerYAnchor.constraint(equalTo: (ribbonView?.centerYAnchor ?? centerYAnchor)),
                    detailLabel.trailingAnchor.constraint(lessThanOrEqualTo: ribbonView?.leadingAnchor ?? trailingAnchor),
                ])
            } else {
                guard let priceLabel = priceLabel else { return }
                addSubview(priceLabel)
                NSLayoutConstraint.activate([
                    priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                    priceLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
                    priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: ribbonView?.leadingAnchor ?? trailingAnchor),

                    detailLabel.topAnchor.constraint(equalTo: (ribbonView?.bottomAnchor ?? titleLabel.bottomAnchor), constant: .smallSpacing),
                    detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
            }
        }
    }

    private func teardownView() {
        adImageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        priceLabel?.removeFromSuperview()
        ribbonView?.removeFromSuperview()
        detailLabel.removeFromSuperview()
    }

    private func setupRibbonView(forUserAdStatus status: UserAdStatus) {
        ribbonView?.removeFromSuperview()

        switch status {
        case .draft: ribbonView = RibbonView(style: .warning, with: status.rawValue)
        case .active: ribbonView = RibbonView(style: .success, with: status.rawValue)
        case .inactive: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .expired: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .sold: ribbonView = RibbonView(style: .warning, with: status.rawValue)
        case .unknown: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        }

        if let ribbon = ribbonView {
            ribbon.translatesAutoresizingMaskIntoConstraints = false
            ribbon.setContentCompressionResistancePriority(.required, for: .horizontal)
            addSubview(ribbon)
            NSLayoutConstraint.activate([
                ribbon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ribbon.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adImageView.image = nil
        titleLabel.text = nil
        priceLabel?.text = nil
        detailLabel.text = nil
        accessibilityLabel = nil

        if let model = model {
            dataSource?.userAdsListViewCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    public var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            priceLabel?.text = model.price
            detailLabel.text = model.detail
            userAdStatus = UserAdStatus(rawValue: model.status) ?? .unknown
            accessibilityLabel = model.accessibilityLabel

            setupRibbonView(forUserAdStatus: userAdStatus)
            setupView()
        }
    }

    // MARK: - Public

    public func loadImage() {
        if let model = model {
            loadImage(model)
        }
    }

    /// Loads a given image provided that the imagePath in the `model` is valid.

    private func loadImage(_ model: UserAdsListViewModel) {
        guard let dataSource = dataSource, model.imagePath != nil else {
            loadingColor = .clear
            adImageView.image = defaultImage
            return
        }

        adImageView.backgroundColor = loadingColor

        dataSource.userAdsListViewCell(self, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear
            self?.adImageView.image = image ?? self?.defaultImage
        }
    }
}
