//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol NotificationsListFooterViewDelegate: AnyObject {
    func notificationsListFooterView(_ notificationsListFooterView: NotificationsListFooterView, didSelectFooterViewAtSection section: Int)
}

public class NotificationsListFooterView: UITableViewHeaderFooterView {
    weak var delegate: NotificationsListFooterViewDelegate?
    var section: Int = 0

    lazy var titleLabel: UILabel = {
        let label = Label(style: .detail)
        label.textColor = .textLink
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS)
        ])
    }

    @objc func tapped() {
        delegate?.notificationsListFooterView(self, didSelectFooterViewAtSection: section)
    }

    // MARK: - Dependency injection

    /// The model contains data used to populate the view.
    public var group: NotificationsGroupListViewModel? {
        didSet {
            titleLabel.text = group?.footerAction
        }
    }
}
