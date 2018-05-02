//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol NotificationsListHeaderViewDelegate: class {
    func notificationsListHeaderView(_ notificationsListHeaderView: NotificationsListHeaderView, didSelectHeaderViewAtSection section: Int)
}

public class NotificationsListHeaderView: UITableViewHeaderFooterView {
    weak var delegate: NotificationsListHeaderViewDelegate?
    var section: Int = 0

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

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -.mediumSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        ])
    }

    @objc func tapped() {
        delegate?.notificationsListHeaderView(self, didSelectHeaderViewAtSection: section)
    }

    // MARK: - Dependency injection

    /// The model contains data used to populate the view.
    public var group: NotificationsGroupListViewModel? {
        didSet {
            titleLabel.attributedText = group?.attributedTitle
            dateLabel.text = group?.timeAgo
        }
    }
}
