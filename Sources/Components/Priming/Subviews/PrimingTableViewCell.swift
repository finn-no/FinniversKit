//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PrimingTableViewCell: UITableViewCell {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .btnPrimary
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(withIcon icon: UIImage, title: String, detailText: String) {
        iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title
        detailLabel.text = detailText
    }

    private func setup() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)

        layoutMargins = UIEdgeInsets(top: 13, leading: 34, bottom: 13, trailing: 40)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 56),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
