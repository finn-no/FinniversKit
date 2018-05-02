//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class NotificationsListHeaderView: UITableViewHeaderFooterView {
    lazy var titleLabel: UILabel = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = Label(style: .detail(.stone))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -.mediumSpacing),

            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        ])
    }
}
