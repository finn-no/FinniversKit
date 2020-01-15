//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

class NotificationCenterSectionHeaderView: UITableViewHeaderFooterView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .textSecondary
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .bgPrimary
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),

            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String?) {
        titleLabel.text = title
    }
}
