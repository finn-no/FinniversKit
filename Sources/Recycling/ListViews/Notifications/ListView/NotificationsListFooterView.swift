//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol NotificationsListFooterViewDelegate: class {
    func notificationsListFooterView(_ notificationsListFooterView: NotificationsListFooterView, didSelectFooterViewAtSection section: Int)
}

class NotificationsListFooterView: UITableViewHeaderFooterView {
    lazy var titleLabel: UILabel = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        ])
    }
    
    @objc func tapped() {
        delegate?.notificationsListHeaderView(self, didSelectFooterViewAtSection: section)
    }
}
