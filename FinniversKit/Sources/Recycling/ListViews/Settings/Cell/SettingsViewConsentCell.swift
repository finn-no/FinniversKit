//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

class SettingsViewConsentCell: SettingsViewCell {

    private lazy var statusLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textSubtle
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil, isLastItem: false)
    }

    override func setup() {
        super.setup()

        contentView.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 0),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing100)
        ])
    }
}

extension SettingsViewConsentCell {
    func configure(with model: SettingsViewConsentCellModel?, isLastItem: Bool) {
        super.configure(with: model, isLastItem: isLastItem)
        statusLabel.text = model?.status
    }
}
