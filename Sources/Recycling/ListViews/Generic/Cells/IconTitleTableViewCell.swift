//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol IconTitleTableViewCellViewModel: BasicTableViewCellViewModel {
    var icon: UIImage? { get }
    var iconTintColor: UIColor? { get }
    var hasChevron: Bool { get }
}

open class IconTitleTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Setup

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, layoutInSubclass: true)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, layoutInSubclass: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if !layoutInSubclass {
            setup()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open override func prepareForReuse() {
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = UIImageView.appearance().tintColor
    }

    open func configure(with viewModel: IconTitleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        accessoryType = viewModel.hasChevron ? .disclosureIndicator : .none
        if let icon = viewModel.icon {
            iconImageView.image = icon
            if let tintColor = viewModel.iconTintColor {
                iconImageView.tintColor = tintColor
            }
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumSpacing).isActive = true
        } else {
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing).isActive = true
        }
        setNeedsLayout()

        separatorInset = UIEdgeInsets(top: 0, leading: .mediumLargeSpacing, bottom: 0, trailing: 0)
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
