//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListViewInactiveCellDataSource: class {
    func userAdsListViewInactiveCell(_ userAdsListViewInactiveCell: UserAdsListViewInactiveCell,
                                     loadImageForModel model: UserAdsListViewModel,
                                     imageWidth: CGFloat,
                                     completion: @escaping ((UIImage?) -> Void))

    func userAdsListViewInactiveCell(_ userAdsListViewInactiveCell: UserAdsListViewInactiveCell,
                                     cancelLoadingImageForModel model: UserAdsListViewModel,
                                     imageWidth: CGFloat)
}

public class UserAdsListViewInactiveCell: UITableViewCell {
    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.

    public var loadingColor: UIColor?

    /// A data source for the loading of the image

    public weak var dataSource: UserAdsListViewInactiveCellDataSource?

    // MARK: - Internal properties

    private static let cornerRadius: CGFloat = 12
    private static let imageSize: CGFloat = 56

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = UserAdsListViewInactiveCell.cornerRadius
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

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .milk
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: (UserAdsListViewInactiveCell.imageSize + .mediumSpacing), bottom: 0, right: 0)

        addSubview(adImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            adImageView.heightAnchor.constraint(equalToConstant: UserAdsListViewInactiveCell.imageSize),
            adImageView.widthAnchor.constraint(equalToConstant: UserAdsListViewInactiveCell.imageSize),
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),
            adImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: accessoryView?.leadingAnchor ?? trailingAnchor, constant: -.largeSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: adImageView.centerYAnchor),
        ])
    }

    private func setupRibbonView(forUserAdStatus status: UserAdStatus) {
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

        guard let ribbonView = ribbonView else { return }
        ribbonView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ribbonView)
        NSLayoutConstraint.activate([
            ribbonView.trailingAnchor.constraint(equalTo: accessoryView?.leadingAnchor ?? contentView.trailingAnchor),
            ribbonView.centerYAnchor.constraint(equalTo: accessoryView?.centerYAnchor ?? contentView.centerYAnchor),
        ])
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adImageView.image = nil
        titleLabel.text = nil
        ribbonView = nil
        accessibilityLabel = nil

        if let model = model {
            dataSource?.userAdsListViewInactiveCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    public var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            setupRibbonView(forUserAdStatus: UserAdStatus.init(rawValue: model.status) ?? .unknown)
            accessibilityLabel = model.accessibilityLabel
        }
    }

    // MARK: - Public

    func loadImage() {
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

        dataSource.userAdsListViewInactiveCell(self, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear
            self?.adImageView.image = image ?? self?.defaultImage
        }
    }
}
