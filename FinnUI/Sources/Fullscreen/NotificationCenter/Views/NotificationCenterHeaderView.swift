//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterHeaderViewModel {
    var title: String? { get }
    var markAllAsReadTitle: String? { get }
    var savedSearchButtonModel: SavedSearchHeaderButtonModel? { get }
}

protocol NotificationCenterHeaderViewDelegate: AnyObject {
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectSavedSearchButtonInSection section: Int)
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectMarkAllAsReadButtonInSection section: Int)
}

final class NotificationCenterHeaderView: UITableViewHeaderFooterView {

    weak var delegate: NotificationCenterHeaderViewDelegate?

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var titleLabel = Label(
        style: .title3Strong,
        withAutoLayout: true
    )

    private lazy var markAllAsReadButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleMarkAllAsReadButton), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()

    private lazy var savedSearchButton: SavedSearchHeaderButton = {
        let button = SavedSearchHeaderButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSavedSearchButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, savedSearchButton])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var stackViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)

    private var section: Int?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: NotificationCenterHeaderViewModel?, inSection section: Int) {
        self.section = section
        titleLabel.text = model?.title
        markAllAsReadButton.setTitle(model?.markAllAsReadTitle, for: .normal)
        markAllAsReadButton.isHidden = model?.markAllAsReadTitle == nil

        if let savedSearchButtonModel = model?.savedSearchButtonModel {
            savedSearchButton.configure(with: savedSearchButtonModel)
            savedSearchButton.isHidden = false
            stackViewBottomConstraint.constant = 0
        } else {
            savedSearchButton.isHidden = true
            stackViewBottomConstraint.constant = .spacingS
        }
    }
}

private extension NotificationCenterHeaderView {
    @objc func handleSavedSearchButtonSelected() {
        guard let section = section else { return }
        delegate?.notificationCenterHeaderView(self, didSelectSavedSearchButtonInSection: section)
    }

    @objc func handleMarkAllAsReadButton() {
        guard let section = section else { return }
        delegate?.notificationCenterHeaderView(self, didSelectMarkAllAsReadButtonInSection: section)
    }

    func setup() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(markAllAsReadButton)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            stackViewBottomConstraint
        ])
    }
}
