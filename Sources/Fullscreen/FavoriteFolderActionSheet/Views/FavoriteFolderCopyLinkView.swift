//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FavoriteFolderCopyLinkViewDelegate: AnyObject {
    func favoriteFolderCopyLinkViewDidSelectButton(_ view: FavoriteFolderCopyLinkView)
}

final class FavoriteFolderCopyLinkView: UIView {
    weak var delegate: FavoriteFolderCopyLinkViewDelegate?

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .favoritesCopyLink).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .licorice
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .licorice
        return label
    }()

    private lazy var button: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
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

    func configure(withButtonTitle buttonTitle: String, description: String) {
        descriptionLabel.text = description
        button.setTitle(buttonTitle, for: .normal)
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .ice

        addSubview(iconImageView)
        addSubview(descriptionLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.widthAnchor.constraint(equalToConstant: FavoriteActionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -.mediumSpacing),

            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Action

    @objc private func handleButtonTap() {
        delegate?.favoriteFolderCopyLinkViewDidSelectButton(self)
    }
}
