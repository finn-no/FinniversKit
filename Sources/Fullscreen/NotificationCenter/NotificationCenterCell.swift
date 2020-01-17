//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterCellModel {
    var pushNotificationDetails: PushNotificationDetails? { get }
    var imagePath: String? { get }
    var title: String { get }
    var ribbonViewModel: RibbonViewModel? { get }
    var read: Bool { get }
}

protocol NotificationCenterCellDelegate: AnyObject {
    func notificationCenterCellDidSelectSavedSearch(_ cell: NotificationCenterCell)
}

class NotificationCenterCell: UITableViewCell {

    // MARK: - Internal properties

    weak var delegate: NotificationCenterCellDelegate?

    weak var imageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = imageViewDataSource
        }
    }

    // MARK: - Private properties

    private let adImageWidth: CGFloat = 80
    private let fallbackImage = UIImage(named: .noImage)

    private lazy var savedSearchLinkView: PushNotificationDetailsView = {
        let view = PushNotificationDetailsView(withAutoLayout: true)
        view.addTarget(self, action: #selector(handleSavedSearchSelected), for: .touchUpInside)
        return view
    }()

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

    private lazy var statusRibbon = RibbonView(
        withAutoLayout: true
    )

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = .mediumSpacing
        return stackView
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

    func configure(with model: NotificationCenterCellModel?, timestamp: String?) {
        savedSearchLinkView.configure(with: model?.pushNotificationDetails, timestamp: timestamp)

        titleLabel.text = model?.title
        titleLabel.font = model?.read == true ? .body : .bodyStrong
        backgroundColor = model?.read == true ? .bgPrimary : .bgSecondary
        separatorInset = .leadingInset(adImageWidth + .largeSpacing)

        if let ribbonViewModel = model?.ribbonViewModel {
            statusRibbon.title = ribbonViewModel.title
            statusRibbon.style = ribbonViewModel.style
            statusRibbon.isHidden = false
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
    @objc func handleSavedSearchSelected() {
        delegate?.notificationCenterCellDidSelectSavedSearch(self)
    }

    func setup() {
        setDefaultSelectedBackgound()

        contentView.addSubview(savedSearchLinkView)
        contentView.addSubview(remoteImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(statusRibbon)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            savedSearchLinkView.topAnchor.constraint(equalTo: contentView.topAnchor),
            savedSearchLinkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            savedSearchLinkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            savedSearchLinkView.heightAnchor.constraint(equalToConstant: 44),

            remoteImageView.topAnchor.constraint(equalTo: savedSearchLinkView.bottomAnchor),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),
            remoteImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.heightAnchor.constraint(equalToConstant: adImageWidth),

            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.centerYAnchor.constraint(equalTo: remoteImageView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
