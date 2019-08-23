//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteActionHeaderView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = FavoriteActionHeaderView.detailTextLabelFont
        label.textColor = .licorice
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var accessoryLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = FavoriteActionHeaderView.accessoryLabelFont
        label.textColor = .licorice
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        return view
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

    func configure(withImage image: UIImage?, detailText: String, accessoryText: String) {
        imageView.image = image
        detailTextLabel.text = detailText
        accessoryLabel.text = accessoryText
    }

    private func setup() {
        backgroundColor = .milk

        addSubview(imageView)
        addSubview(detailTextLabel)
        addSubview(accessoryLabel)
        addSubview(hairlineView)

        layoutMargins = FavoriteActionHeaderView.layoutMargins

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: FavoriteActionHeaderView.imageViewSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            detailTextLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .detailTextLabelTopSpacing),
            detailTextLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            accessoryLabel.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: .accessoryLabelTopSpacing),
            accessoryLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            hairlineView.topAnchor.constraint(equalTo: accessoryLabel.bottomAnchor, constant: .hairlineTopSpacing),
            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: .hairlineHeight),
            hairlineView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}

// MARK: - Static

extension FavoriteActionHeaderView {
    private static let layoutMargins = UIEdgeInsets(
        top: .mediumSpacing,
        left: .mediumLargeSpacing,
        bottom: 0,
        right: .mediumLargeSpacing
    )

    private static let imageViewSize: CGFloat = 56
    private static let detailTextLabelFont = UIFont.body
    private static let accessoryLabelFont = UIFont.bodyStrong

    static func height(forDetailText detailText: String, accessoryText: String, width: CGFloat) -> CGFloat {
        let width = width - layoutMargins.left - layoutMargins.right
        var height = layoutMargins.top

        height += imageViewSize
        height += .detailTextLabelTopSpacing + detailText.height(withConstrainedWidth: width, font: detailTextLabelFont)
        height += .accessoryLabelTopSpacing + accessoryText.height(withConstrainedWidth: width, font: accessoryLabelFont)
        height += .hairlineTopSpacing + .hairlineHeight
        height += layoutMargins.bottom

        return height
    }
}

// MARK: - Private extensions

private extension CGFloat {
    static let detailTextLabelTopSpacing: CGFloat = 10
    static let accessoryLabelTopSpacing: CGFloat = 14
    static let hairlineTopSpacing: CGFloat = 18
    static let hairlineHeight = 1 / UIScreen.main.scale
}
