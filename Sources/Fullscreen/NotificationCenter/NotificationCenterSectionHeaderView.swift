//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterSectionHeaderViewModel {
    var title: String? { get }
    var details: NotificationCenterSectionDetails? { get }
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

    private lazy var detailsView: NotificationCenterSectionDetailsView = {
        let view = NotificationCenterSectionDetailsView(withAutoLayout: true)
        view.addTarget(self, action: #selector(handleDetailsViewSelected), for: .touchUpInside)
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailsView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var stackViewTopConstraint = stackView.topAnchor.constraint(
        equalTo: contentView.topAnchor
    )

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
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
            stackViewTopConstraint.constant = .spacingXL
        } else {
            titleLabel.isHidden = true
            stackViewTopConstraint.constant = 0
        }

        detailsView.configure(with: model?.details)
        detailsView.isHidden = model?.details == nil
    }

    @objc private func handleDetailsViewSelected() {
        guard let section = section else { return }
        delegate?.notificationCenterSectionHeaderView(self, didSelectNotificationDetailsInSection: section)
    }

    private func setup() {
        contentView.backgroundColor = .bgPrimary
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            stackViewTopConstraint,
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])
    }
}
