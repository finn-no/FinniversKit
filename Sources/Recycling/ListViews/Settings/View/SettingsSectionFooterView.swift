//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

class SettingsSectionFooterView: UITableViewHeaderFooterView {

    private lazy var titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String?) {
        titleLabel.text = text
    }

    private func setup() {
        contentView.addSubview(titleLabel)

        let trailingConstraint = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing)
        trailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            trailingConstraint
        ])
    }
}
