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
    
    open lazy var externalIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Private properties

    let iconSize: CGFloat = 24
    let externalIconSize: CGFloat = 16

    private lazy var stackViewToIconConstraint = stackView.leadingAnchor.constraint(
        equalTo: iconImageView.trailingAnchor, constant: .spacingM
    )
    
    
    private lazy var stackViewToExternalIconConstraint = stackView.trailingAnchor.constraint(
        lessThanOrEqualTo: externalIconImageView.leadingAnchor, constant: -.spacingS
    )

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

            // align it with the text, considering the size of the icon
            separatorInset = .leadingInset(.spacingM + iconSize + .spacingM)
        } else {
            stackViewToIconConstraint.isActive = false
            stackViewLeadingAnchorConstraint.isActive = true

            separatorInset = .leadingInset(.spacingM)
        }
        
        stackViewToExternalIconConstraint.isActive = viewModel.externalIcon != nil
        if let externalIcon = viewModel.externalIcon {
            accessoryType = .none
            selectionStyle = .none
            externalIconImageView.image = externalIcon
            if let tintColor = viewModel.iconTintColor {
                externalIconImageView.tintColor = tintColor
            }
        }

        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(externalIconImageView)
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            externalIconImageView.heightAnchor.constraint(equalToConstant: externalIconSize),
            externalIconImageView.widthAnchor.constraint(equalToConstant: externalIconSize),
            externalIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            externalIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
