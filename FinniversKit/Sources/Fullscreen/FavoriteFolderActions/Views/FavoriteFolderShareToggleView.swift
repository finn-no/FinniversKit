//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol FavoriteFolderShareToggleViewDelegate: AnyObject {
    func favoriteFolderShareToggleView(_ view: FavoriteFolderShareToggleView, didChangeValueFor switchControl: UISwitch)
}

final class FavoriteFolderShareToggleView: UIView {
    weak var delegate: FavoriteFolderShareToggleViewDelegate?

    var isSeparatorHidden = true {
        didSet {
            separatorView.isHidden = isSeparatorHidden
        }
    }

    var isEnabled = true {
        didSet {
            titleLabel.textColor = isEnabled ? .text : .textDisabled
            iconImageView.tintColor = isEnabled ? .icon : .backgroundDisabled
            switchControl.isEnabled = isEnabled
        }
    }

    private lazy var titleLabel = FavoriteActionCell.makeTitleLabel()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .favoritesShare).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .icon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var switchControl: UISwitch = {
        let control = UISwitch(withAutoLayout: true)
        control.onTintColor = .backgroundPrimary
        control.addTarget(self, action: #selector(handleSwitchValueChange), for: .valueChanged)
        return control
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .border
        view.isHidden = isSeparatorHidden
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

    func configure(withTitle title: String, switchOn: Bool) {
        titleLabel.text = title
        switchControl.isOn = switchOn
    }

    private func setup() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(switchControl)
        addSubview(separatorView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            iconImageView.widthAnchor.constraint(equalToConstant: FavoriteActionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -Warp.Spacing.spacing200),

            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),

            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    // MARK: - Action

    @objc private func handleSwitchValueChange() {
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            self.delegate?.favoriteFolderShareToggleView(self, didChangeValueFor: self.switchControl)
        }
    }
}
