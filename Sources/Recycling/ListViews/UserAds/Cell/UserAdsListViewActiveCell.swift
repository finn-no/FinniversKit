//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Shared enum used between `UserAdsListViewActiveCell` and `UserAdsListViewInactiveCell`
public enum UserAdStatus: String {
    case started = "Påbegynt"
    case active = "Aktiv"
    case inactive = "Inaktiv"
    case expired = "Utløpt"
    case sold = "Solgt"
    case unknown = "Ukjent"
}

public protocol UserAdsListViewActiveCellDataSource: class {
    func userAdsListViewActiveCell(_ userAdsListViewActiveCell: UserAdsListViewActiveCell, loadImageForModel model: UserAdsListViewModel,
                                   imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func userAdsListViewActiveCell(_ userAdsListViewActiveCell: UserAdsListViewActiveCell, cancelLoadingImageForModel model: UserAdsListViewModel, imageWidth: CGFloat)
}

public class UserAdsListViewActiveCell: UITableViewCell {
    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.

    public var loadingColor: UIColor?

    /// A data source for the loading of the image

    public weak var dataSource: UserAdsListViewActiveCellDataSource?

    // MARK: - Internal properties

    private static let cornerRadius: CGFloat = 12
    private static let imageSize: CGFloat = 100

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = UserAdsListViewActiveCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .title5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .stone
        label.backgroundColor = .clear
        return label
    }()

    private lazy var ribbonView: RibbonView? = nil

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public func setup() {
        isAccessibilityElement = true
        backgroundColor = .milk
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: (UserAdsListViewActiveCell.imageSize + .mediumSpacing), bottom: 0, right: 0)

        addSubview(adImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(detailLabel)

        NSLayoutConstraint.activate([
            adImageView.heightAnchor.constraint(equalToConstant: UserAdsListViewActiveCell.imageSize),
            adImageView.widthAnchor.constraint(equalToConstant: UserAdsListViewActiveCell.imageSize),
            adImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),

            priceLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            priceLabel.trailingAnchor.constraint(equalTo: ribbonView?.leadingAnchor ?? trailingAnchor),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: ribbonView?.leadingAnchor ?? trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -.mediumSpacing),

            detailLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: ribbonView?.leadingAnchor ?? trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: .mediumSpacing),
        ])
    }

    public func setupRibbonView(forUserAdStatus status: UserAdStatus) {
        ribbonView?.removeFromSuperview()
        ribbonView = nil

        switch status {
        case .started: ribbonView = RibbonView(style: .warning, with: status.rawValue)
        case .active: ribbonView = RibbonView(style: .success, with: status.rawValue)
        case .inactive: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .expired: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .sold: ribbonView = RibbonView(style: .warning, with: status.rawValue)
        case .unknown: return
        }

        if let view = ribbonView {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: accessoryView?.centerYAnchor ?? contentView.centerYAnchor),
                view.trailingAnchor.constraint(equalTo: accessoryView?.leadingAnchor ?? contentView.trailingAnchor),
            ])
        }
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        detailLabel.text = nil
        ribbonView = nil
        accessibilityLabel = nil

        if let model = model {
            dataSource?.userAdsListViewActiveCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    public var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            priceLabel.text = model.price
            detailLabel.text = model.detail
            setupRibbonView(forUserAdStatus: UserAdStatus(rawValue: model.status) ?? .unknown)
            accessibilityLabel = model.accessibilityLabel
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

        dataSource.userAdsListViewActiveCell(self, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear
            self?.adImageView.image = image ?? self?.defaultImage
        }
    }
}
