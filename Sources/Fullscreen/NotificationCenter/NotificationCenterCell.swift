//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterCellModel {
    var imagePath: String? { get }
    var title: String { get }
    var date: String { get }
    var read: Bool { get }
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
        imageView.layer.borderColor = .imageBorder
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var dateLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

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
        configure(with: nil)
        remoteImageView.cancelLoading()
    }

    func configure(with model: NotificationCenterCellModel?) {
        titleLabel.text = model?.title
        dateLabel.text = model?.date
        contentView.backgroundColor = model?.read == true ? .bgPrimary : .bgSecondary

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
        contentView.addSubview(remoteImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),
            remoteImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.heightAnchor.constraint(equalToConstant: adImageWidth),

            titleLabel.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: remoteImageView.centerYAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing)
        ])
    }
}
