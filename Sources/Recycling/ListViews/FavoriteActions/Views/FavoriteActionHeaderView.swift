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
        label.font = .body
        label.textColor = .licorice
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var accessoryLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .licorice
        label.textAlignment = .center
        label.numberOfLines = 0
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

        layoutMargins = UIEdgeInsets(top: .mediumSpacing, left: .mediumLargeSpacing, bottom: 0, right: .mediumLargeSpacing)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 56),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            detailTextLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumSpacing),
            detailTextLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            accessoryLabel.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: 12),
            accessoryLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            hairlineView.topAnchor.constraint(equalTo: accessoryLabel.bottomAnchor, constant: 18),
            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            hairlineView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}
