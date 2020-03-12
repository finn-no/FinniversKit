//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterCellModel {
    var imagePath: String? { get }
    var title: String { get }
    var priceText: String? { get }
    var ribbonViewModel: RibbonViewModel? { get }
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
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var priceLabel = Label(
        style: .bodyStrong,
        withAutoLayout: true
    )

    private lazy var timestampLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private lazy var statusRibbon = RibbonView(
        withAutoLayout: true
    )

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            priceLabel,
            timestampLabel,
            statusRibbon
        ])

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
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
        remoteImageView.image = nil
        remoteImageView.cancelLoading()
        configure(with: nil, timestamp: nil)
    }

    func configure(with model: NotificationCenterCellModel?, timestamp: String?, hideSeparator: Bool = false) {
        titleLabel.text = model?.title
        timestampLabel.text = timestamp

        titleLabel.font = model?.read == true ? .body : .bodyStrong
        backgroundColor = model?.read == true ? .bgPrimary : .bgSecondary
        separatorView.isHidden = hideSeparator

        priceLabel.text = model?.priceText
        priceLabel.isHidden = model?.priceText == nil

        if let ribbonViewModel = model?.ribbonViewModel {
            statusRibbon.configure(with: ribbonViewModel)
        } else {
            statusRibbon.isHidden = true
        }

        guard let imagePath = model?.imagePath else {
            remoteImageView.image = fallbackImage
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
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)

        stackView.setCustomSpacing(.spacingS, after: titleLabel)
        stackView.setCustomSpacing(.spacingXS, after: priceLabel)
        stackView.setCustomSpacing(.spacingS, after: timestampLabel)

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            remoteImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.heightAnchor.constraint(equalToConstant: adImageWidth),

            stackView.topAnchor.constraint(equalTo: remoteImageView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: remoteImageView.bottomAnchor, constant: .spacingM),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: .spacingM)
        ])
    }
}
