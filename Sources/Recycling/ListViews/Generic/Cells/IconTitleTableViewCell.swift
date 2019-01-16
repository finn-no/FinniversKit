//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

open class IconTitleTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Private properties

    private lazy var stackViewToIconConstraint = stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumSpacing)

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        iconImageView.tintColor = UIImageView.appearance().tintColor
    }

    open func configure(with viewModel: IconTitleTableViewCellViewModel) {
        super.configure(with: viewModel)
        selectionStyle = .default

        if let icon = viewModel.icon {
            iconImageView.image = icon
            if let tintColor = viewModel.iconTintColor {
                iconImageView.tintColor = tintColor
            }
            stackViewLeadingAnchorConstraint.isActive = false
            stackViewToIconConstraint.isActive = true
        } else {
            stackViewToIconConstraint.isActive = false
            stackViewLeadingAnchorConstraint.isActive = true
        }

        separatorInset = .leadingInset(.mediumLargeSpacing)

        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
