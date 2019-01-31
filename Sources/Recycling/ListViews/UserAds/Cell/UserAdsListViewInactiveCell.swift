//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class UserAdsListViewInactiveCell: UserAdsListViewActiveCell {
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

    public override func setup() {
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

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adImageView.image = nil
        titleLabel.text = nil
        ribbonView = nil
        accessibilityLabel = nil

        if let model = model {
            dataSource?.userAdsListViewActiveCell(self, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    public override var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            setupRibbonView(forUserAdStatus: UserAdStatus.init(rawValue: model.status) ?? .unknown)
            accessibilityLabel = model.accessibilityLabel
        }
    }

    // MARK: - Public

    public override func loadImage() {
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
