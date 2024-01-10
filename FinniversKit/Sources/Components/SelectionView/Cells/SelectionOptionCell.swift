//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

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
        checkmarkImageView.backgroundColor = .nmpBrandControlSelected
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .nmpBrandControlSelected
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
        backgroundColor = .bgPrimary
        setDefaultSelectedBackgound()
        hideCheckmark(true)

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            iconImageView.widthAnchor.constraint(equalToConstant: SelectionOptionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -.spacingS),

            checkmarkImageView.heightAnchor.constraint(equalToConstant: .spacingM),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: .spacingM),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func hideCheckmark(_ hide: Bool) {
        iconImageView.tintColor = hide ? .iconPrimary : .nmpBrandControlSelected

        titleLabel.font = hide ? .body : .bodyStrong
        titleLabel.textColor = iconImageView.tintColor

        checkmarkImageView.isHidden = hide
    }
}
