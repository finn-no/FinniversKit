//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterCellModel {
    var imagePath: String? { get }
    var title: String { get }
    var subtitle: String { get }
    var price: String { get }
    var date: String { get }
    var read: Bool { get }
    var imageSource: NotificationCenterCellImageSource? { get }
}

public protocol NotificationCenterCellImageSource: AnyObject {
    func notificationCenterCell(_ cell: NotificationCenterCell, loadImageAt path: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

public class NotificationCenterCell: UITableViewCell {

    private weak var imageSource: NotificationCenterCellImageSource?

    private let adImageWidth: CGFloat = 80

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.sardine.cgColor
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

    private lazy var dateLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: NotificationCenterCellModel?) {
        titleLabel.text = model?.title
        subtitleLabel.text = model?.subtitle
        priceLabel.text = model?.price
        dateLabel.text = model?.date
        adImageView.image = UIImage(named: .noImage)
        contentView.backgroundColor = model?.read == true ? .bgPrimary : .bgSecondary

        guard let imagePath = model?.imagePath else {
            return
        }

        model?.imageSource?.notificationCenterCell(self, loadImageAt: imagePath, completion: { result in
            switch result {
            case .success(let image):
                guard let image = image else { return }
                self.adImageView.image = image
            case .failure:
                break
            }
        })
    }
}

private extension NotificationCenterCell {
    func setup() {
        contentView.addSubview(adImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            adImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),
            adImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            adImageView.heightAnchor.constraint(equalToConstant: adImageWidth),

            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: adImageView.topAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            dateLabel.topAnchor.constraint(equalTo: adImageView.topAnchor),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: adImageView.bottomAnchor)
        ])
    }
}
