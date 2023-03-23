//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

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
            titleLabel.textColor = isEnabled ? .textPrimary : .textDisabled
            iconImageView.tintColor = isEnabled ? .iconPrimary : .decorationSubtle
            switchControl.isEnabled = isEnabled
        }
    }

    private lazy var titleLabel = FavoriteActionCell.makeTitleLabel()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .favoritesShare).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var switchControl: UISwitch = {
        let control = UISwitch(withAutoLayout: true)
        control.onTintColor = .btnPrimary
        control.addTarget(self, action: #selector(handleSwitchValueChange), for: .valueChanged)
        return control
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled
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
        backgroundColor = .bgPrimary

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(switchControl)
        addSubview(separatorView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            iconImageView.widthAnchor.constraint(equalToConstant: FavoriteActionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -.spacingM),

            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

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
