//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterHeaderViewModel {
    var title: String? { get }
    var savedSearchButtonModel: SavedSearchHeaderButtonModel? { get }
    var includeMoreButton: Bool { get }
}

protocol NotificationCenterHeaderViewDelegate: AnyObject {
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectSavedSearchButtonInSection section: Int)
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectMoreButtonInSection section: Int)
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

    private lazy var moreButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.setImage(UIImage(named: .more).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleMoreButtonSelected), for: .touchUpInside)
        // increate the tapable area as the button is not too big to begin with
        button.contentEdgeInsets = UIEdgeInsets(leading: .spacingL)
        button.tintColor = .textSecondary
        return button
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [savedSearchButton, moreButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .bottom
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, horizontalStackView])
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

        let includeMoreButton = model?.includeMoreButton ?? false
        moreButton.isHidden = !includeMoreButton
    }
}

private extension NotificationCenterHeaderView {
    @objc func handleSavedSearchButtonSelected() {
        guard let section = section else { return }
        delegate?.notificationCenterHeaderView(self, didSelectSavedSearchButtonInSection: section)
    }

    @objc func handleMoreButtonSelected() {
        guard let section = section else { return }
        delegate?.notificationCenterHeaderView(self, didSelectMoreButtonInSection: section)
    }

    func setup() {
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackViewBottomConstraint
        ])
    }
}
