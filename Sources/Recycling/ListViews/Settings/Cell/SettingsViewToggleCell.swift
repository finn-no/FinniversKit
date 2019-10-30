//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol SettingsViewToggleCellDelegate: AnyObject {
    func settingsViewToggleCell(_ cell: SettingsViewToggleCell, didToggleSettingFor model: SettingsViewToggleCellModel)
}

class SettingsViewToggleCell: SettingsViewCell {

    // MARK: - Internal Properties

    weak var delegate: SettingsViewToggleCellDelegate?

    // MARK: - Private Properties

    private var model: SettingsViewToggleCellModel?

    private lazy var uiswitch: UISwitch = {
        let toggle = UISwitch(withAutoLayout: true)
        toggle.onTintColor = .primaryBlue
        toggle.addTarget(self, action: #selector(handleValueChanged(toggle:)), for: .valueChanged)
        return toggle
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil, isLastItem: false)
    }

    override func setup() {
        super.setup()

        contentView.addSubview(uiswitch)

        NSLayoutConstraint.activate([
            uiswitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiswitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

extension SettingsViewToggleCell {
    func configure(with model: SettingsViewToggleCellModel?, isLastItem: Bool) {
        super.configure(with: model, isLastItem: isLastItem)
        self.model = model
        uiswitch.isOn = model?.isOn ?? false
    }
}

private extension SettingsViewToggleCell {
    @objc func handleValueChanged(toggle: UISwitch) {
        guard var model = model else {
            return
        }

        model.isOn = toggle.isOn
        delegate?.settingsViewToggleCell(self, didToggleSettingFor: model)
    }
}
