//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterHeaderViewModel {
    var title: String? { get }
    var savedSearchButtonModel: SavedSearchHeaderButtonModel? { get }
}

protocol NotificationCenterHeaderViewDelegate: AnyObject {
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectSavedSearchButtonInSection section: Int)
}

final class NotificationCenterHeaderView: UITableViewHeaderFooterView {

    weak var delegate: NotificationCenterHeaderViewDelegate?

    private lazy var titleLabel = Label(
        style: .title3Strong,
        withAutoLayout: true
    )

    private lazy var savedSearchButton: SavedSearchHeaderButton = {
        let button = SavedSearchHeaderButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSavedSearchButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, savedSearchButton])
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

    func setup() {
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            stackViewBottomConstraint
        ])
    }
}
