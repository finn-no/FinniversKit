//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol NeighborhoodProfileButtonViewCellDelegate: AnyObject {
    func neighborhoodProfileButtonViewCellDidSelectLinkButton(_ view: NeighborhoodProfileButtonViewCell)
}

final class NeighborhoodProfileButtonViewCell: NeighborhoodProfileViewCell {
    typealias Content = NeighborhoodProfileViewModel.Content

    weak var delegate: NeighborhoodProfileButtonViewCellDelegate?
    private(set) var linkButtonUrl: URL?

    private lazy var titleLabel: UILabel = makeTitleLabel()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var linkButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    func configure(withContent content: Content) {
        titleLabel.text = content.title
        linkButton.setTitle(content.link?.title, for: .normal)
        linkButtonUrl = content.link?.url
        iconImageView.image = content.icon
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(linkButton)
        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200),

            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: Warp.Spacing.spacing200),
            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: linkButton.topAnchor, constant: -Warp.Spacing.spacing200),
            iconImageView.widthAnchor.constraint(equalToConstant: NeighborhoodProfileButtonViewCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            linkButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            linkButton.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing200)
        ])
    }

    // MARK: - Actions

    @objc private func handleLinkButtonTap() {
        delegate?.neighborhoodProfileButtonViewCellDidSelectLinkButton(self)
    }
}

// MARK: - Static

extension NeighborhoodProfileButtonViewCell {
    private static let linkButtonHeight: CGFloat = 44
    private static let iconSize: CGFloat = 80

    static func height(forContent content: Content, width: CGFloat) -> CGFloat {
        let width = width - Warp.Spacing.spacing200 * 2
        var height = Warp.Spacing.spacing200

        // Title label
        height += content.title.height(withConstrainedWidth: width, font: titleFont)

        // Icon image view
        if content.icon != nil {
            height += iconSize + Warp.Spacing.spacing200 * 2
        }

        // Link button
        if content.link != nil {
            height += linkButtonHeight
        }

        height += Warp.Spacing.spacing200

        return height
    }
}
