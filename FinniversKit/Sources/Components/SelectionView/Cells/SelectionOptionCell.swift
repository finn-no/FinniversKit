//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

final class SelectionOptionCell: UITableViewCell {
    static let iconSize: CGFloat = 24

    var isCheckmarkHidden = true {
        didSet {
            hideCheckmark(isCheckmarkHidden)
        }
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel = UILabel(withAutoLayout: true)

    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView.checkmarkImageView
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.backgroundColor = .backgroundPrimary
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .backgroundPrimary
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hideCheckmark(true)
    }

    // MARK: - Public

    func configure(withTitle title: String, icon: UIImage) {
        titleLabel.text = title
        iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
    }

    // MARK: - Private methods

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .background
        setDefaultSelectedBackgound()
        hideCheckmark(true)

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            iconImageView.widthAnchor.constraint(equalToConstant: SelectionOptionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -Warp.Spacing.spacing100),

            checkmarkImageView.heightAnchor.constraint(equalToConstant: Warp.Spacing.spacing200),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Warp.Spacing.spacing200),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func hideCheckmark(_ hide: Bool) {
        iconImageView.tintColor = hide ? .iconPrimary : .backgroundPrimary

        titleLabel.font = hide ? .body : .bodyStrong
        titleLabel.textColor = iconImageView.tintColor

        checkmarkImageView.isHidden = hide
    }
}
