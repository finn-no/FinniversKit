//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterCellModel: SavedSearchLinkViewModel {
    var imagePath: String? { get }
    var title: String { get }
    var timestamp: String { get }
    var read: Bool { get }
    var statusTitle: String? { get }
    var statusStyle: RibbonView.Style? { get }
}

class NotificationCenterCell: UITableViewCell {

    // MARK: - Internal properties

    weak var imageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = imageViewDataSource
        }
    }

    // MARK: - Private properties

    private let adImageWidth: CGFloat = 80
    private let fallbackImage = UIImage(named: .noImage)

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = .tableViewSeparator
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var statusRibbon = RibbonView(
        withAutoLayout: true
    )

    private lazy var savedSearchLinkView = SavedSearchLinkView(
        withAutoLayout: true
    )

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var timestampLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private lazy var imageToStatusRibbonConstraint = remoteImageView.topAnchor.constraint(
        equalTo: statusRibbon.bottomAnchor,
        constant: .smallSpacing
    )

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func prepareForReuse() {
        remoteImageView.image = nil
        remoteImageView.cancelLoading()
        configure(with: nil)
    }

    func configure(with model: NotificationCenterCellModel?) {
        savedSearchLinkView.configure(with: model)
        titleLabel.text = model?.title
        timestampLabel.text = model?.timestamp
        backgroundColor = model?.read == true ? .bgPrimary : .bgSecondary
        separatorInset = .leadingInset(.largeSpacing + adImageWidth)

        if let statusTitle = model?.statusTitle, let statusStyle = model?.statusStyle {
            statusRibbon.title = statusTitle
            statusRibbon.style = statusStyle
            statusRibbon.isHidden = false
            imageToStatusRibbonConstraint.isActive = true
        } else {
            statusRibbon.isHidden = true
            imageToStatusRibbonConstraint.isActive = false
        }

        guard let imagePath = model?.imagePath else {
            return
        }

        remoteImageView.loadImage(
            for: imagePath,
            imageWidth: adImageWidth,
            loadingColor: nil,
            fallbackImage: fallbackImage
        )
    }
}

// MARK: - Private methods
private extension NotificationCenterCell {
    func setup() {
        setDefaultSelectedBackgound()

        contentView.addSubview(remoteImageView)
        contentView.addSubview(statusRibbon)
        contentView.addSubview(savedSearchLinkView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timestampLabel)

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),
            remoteImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.heightAnchor.constraint(equalToConstant: adImageWidth),

            statusRibbon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            statusRibbon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),

            savedSearchLinkView.topAnchor.constraint(equalTo: remoteImageView.topAnchor),
            savedSearchLinkView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),

            titleLabel.topAnchor.constraint(equalTo: savedSearchLinkView.bottomAnchor, constant: .smallSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: timestampLabel.topAnchor),

            timestampLabel.bottomAnchor.constraint(equalTo: remoteImageView.bottomAnchor),
            timestampLabel.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
        ])
    }
}
