//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

class SettingsSectionHeaderView: UITableViewHeaderFooterView {

    private lazy var titleLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        label.textColor = .textSecondary
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

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }
}
