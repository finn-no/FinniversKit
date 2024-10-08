//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol FavoriteFolderShareLinkViewDelegate: AnyObject {
    func favoriteFolderShareLinkViewDidSelectButton(_ view: FavoriteFolderShareLinkView)
}

final class FavoriteFolderShareLinkView: UIView {
    weak var delegate: FavoriteFolderShareLinkViewDelegate?

    var isEnabled = true {
        didSet {
            iconImageView.tintColor = isEnabled ? .icon : .backgroundDisabled
            descriptionLabel.textColor = isEnabled ? .text : .textDisabled
            button.isEnabled = isEnabled
        }
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .favoritesShareLink).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .icon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .text
        label.adjustsFontSizeToFitWidth = true
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
        backgroundColor = .backgroundSubtle

        addSubview(iconImageView)
        addSubview(descriptionLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            iconImageView.widthAnchor.constraint(equalToConstant: FavoriteActionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Warp.Spacing.spacing200),
            descriptionLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor),

            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Action

    @objc private func handleButtonTap() {
        delegate?.favoriteFolderShareLinkViewDidSelectButton(self)
    }
}
