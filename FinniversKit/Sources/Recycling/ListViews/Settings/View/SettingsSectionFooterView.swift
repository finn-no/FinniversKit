//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit
import Warp

class SettingsSectionFooterView: UITableViewHeaderFooterView {

    private lazy var titleLabel: Label = {
        let label = Label(
            style: .caption,
            numberOfLines: 0,
            withAutoLayout: true
        )
        label.textColor = .textSubtle
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

        let trailingConstraint = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -Warp.Spacing.spacing200)
        trailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Warp.Spacing.spacing100),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trailingConstraint
        ])
    }
}
