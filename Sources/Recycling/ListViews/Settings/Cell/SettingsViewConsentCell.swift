//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Bootstrap

class SettingsViewConsentCell: SettingsViewCell {

    private lazy var statusLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textSecondary
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
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}

extension SettingsViewConsentCell {
    func configure(with model: SettingsViewConsentCellModel?, isLastItem: Bool) {
        super.configure(with: model, isLastItem: isLastItem)
        statusLabel.text = model?.status
    }
}
