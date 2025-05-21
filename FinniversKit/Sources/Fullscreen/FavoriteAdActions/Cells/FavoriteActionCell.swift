//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

final class FavoriteActionCell: UITableViewCell {
    static let iconSize: CGFloat = 24
    static let separatorLeadingInset = Warp.Spacing.spacing200 * 2 + FavoriteActionCell.iconSize
    static let titleLabelStyle = Warp.Typography.bodyStrong
    static let horzontalSpacing = Warp.Spacing.spacing200
    static let verticalSpacing = Warp.Spacing.spacing200

    private lazy var titleLabel = Label(style: Self.titleLabelStyle, numberOfLines: 0, withAutoLayout: true)

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
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.horzontalSpacing),
            iconImageView.widthAnchor.constraint(equalToConstant: Self.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.verticalSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Self.horzontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.horzontalSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.verticalSpacing),
        ])
    }

    static func height(forWidth width: CGFloat, usingText string: String) -> CGFloat {
        let availableTextWidth = width - iconSize - (3 * horzontalSpacing)
        let textHeight = string.height(withConstrainedWidth: availableTextWidth, font: titleLabelStyle.uiFont)
        return textHeight + (2 * verticalSpacing)
    }
}
