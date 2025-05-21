//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

final class FavoriteActionCell: UITableViewCell {
    static let iconSize: CGFloat = 24
    static let separatorLeadingInset = Warp.Spacing.spacing200 * 2 + FavoriteActionCell.iconSize

    private lazy var titleLabel = Label(style: .bodyStrong, numberOfLines: 0, withAutoLayout: true)

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    func configure(withTitle title: String, icon: ImageAsset, tintColor: UIColor = .text) {
        titleLabel.text = title
        titleLabel.textColor = tintColor
        iconImageView.image = UIImage(named: icon).withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = tintColor
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .background
        setDefaultSelectedBackgound()

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            iconImageView.widthAnchor.constraint(equalToConstant: FavoriteActionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200)
        ])
    }
}
