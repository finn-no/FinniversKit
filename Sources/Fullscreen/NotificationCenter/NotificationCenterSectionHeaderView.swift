//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterSectionHeaderViewModel {
    var title: String? { get }
    var details: PushNotificationDetails { get }
}

protocol NotificationCenterSectionHeaderViewDelegate: AnyObject {
    func notificationCenterSectionHeaderView(_ headerView: NotificationCenterSectionHeaderView, didSelectNotificationDetailsInSection section: Int)
}

class NotificationCenterSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Internal properties

    weak var delegate: NotificationCenterSectionHeaderViewDelegate?

    // MARK: - Private properties

    private var section: Int?

    private lazy var titleLabel = Label(
        style: .title3Strong,
        withAutoLayout: true
    )

    private lazy var notificationDetailsView: PushNotificationDetailsView = {
        let view = PushNotificationDetailsView(withAutoLayout: true)
        view.addTarget(self, action: #selector(handleDetailsViewSelected), for: .touchUpInside)
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, notificationDetailsView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .bgPrimary
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil, inSection: 0)
    }

    func configure(with model: NotificationCenterSectionHeaderViewModel?, inSection section: Int) {
        self.section = section

        if let title = model?.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        notificationDetailsView.configure(with: model?.details)
    }

    @objc private func handleDetailsViewSelected() {
        guard let section = section else { return }
        delegate?.notificationCenterSectionHeaderView(self, didSelectNotificationDetailsInSection: section)
    }
}
