//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterCellModel {
    var imagePath: String? { get }
    var title: String { get }
    var timestamp: String { get }
    var read: Bool { get }
    var ribbonModels: [RibbonViewModel] { get }
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

    private lazy var ribbonStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.spacing = .smallSpacing
        return stackView
    }()

    private lazy var timestampLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var timestampToRibbonsConstraint = timestampLabel.leadingAnchor.constraint(
        equalTo: ribbonStackView.trailingAnchor,
        constant: .mediumSpacing
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
        ribbonStackView.subviews.forEach { $0.removeFromSuperview() }
        timestampToRibbonsConstraint.isActive = false
        configure(with: nil)
    }

    func configure(with model: NotificationCenterCellModel?) {
        timestampLabel.text = model?.timestamp
        titleLabel.text = model?.title
        backgroundColor = model?.read == true ? .bgPrimary : .bgSecondary

        if let ribbonModels = model?.ribbonModels, !ribbonModels.isEmpty {
            ribbonModels.forEach { model in
                let ribbonView = RibbonView(style: model.style, with: model.title)
                ribbonStackView.addArrangedSubview(ribbonView)
            }

            timestampToRibbonsConstraint.isActive = true
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
        contentView.addSubview(ribbonStackView)
        contentView.addSubview(timestampLabel)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),
            remoteImageView.widthAnchor.constraint(equalToConstant: 130),
            remoteImageView.heightAnchor.constraint(equalToConstant: 100),

            ribbonStackView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            ribbonStackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),

            timestampLabel.topAnchor.constraint(equalTo: remoteImageView.topAnchor),
            timestampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),

            titleLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
