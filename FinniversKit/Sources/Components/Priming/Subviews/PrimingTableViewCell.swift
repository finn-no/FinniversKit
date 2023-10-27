//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PrimingTableViewCell: UITableViewCell {
    // MARK: - Private properties

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .btnPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: .body, withAutoLayout: true)
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
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    func configure(withIcon icon: UIImage, title: String, detailText: String, iconRenderingMode: UIImage.RenderingMode) {
        iconImageView.image = icon.withRenderingMode(iconRenderingMode)
        titleLabel.attributedText = title.attributedStringWithLineSpacing(.spacingXXS)
        detailLabel.attributedText = detailText.attributedStringWithLineSpacing(.spacingXXS)
    }

    private func setup() {
        backgroundColor = .background

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 56),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXXS),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM)
        ])
    }
}
