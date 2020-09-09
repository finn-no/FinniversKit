//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

protocol NotificationCenterTableHeaderViewDelegate: AnyObject {
    func savedSearchesHeaderViewDidSelectMarkAllAsRead(_ view: NotificationCenterView.SavedSearchesHeaderView)
    func savedSearchesHeaderViewDidSelectGroupSelectionButton(
        _ view: NotificationCenterView.SavedSearchesHeaderView,
        sortingView: UIView
    )
}

extension NotificationCenterView {
    struct SavedSearchesHeaderViewModel {
        let groupSelectionTitle: String
        let markAllAsReadButtonTitle: String
    }

    class SavedSearchesHeaderView: UIView {
        weak var delegate: NotificationCenterTableHeaderViewDelegate?

        var groupSelectionTitle: String {
            get { groupSelectionView.title }
            set { groupSelectionView.title = newValue }
        }

        // MARK: - Private subviews

        private(set) lazy var groupSelectionView: NotificationCenterView.SortView = {
            let view = NotificationCenterView.SortView(withAutoLayout: true)
            view.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(groupSelectionButtonTapped)
            )
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.addGestureRecognizer(tapGestureRecognizer)
            return view
        }()

        private(set) lazy var markAllAsReadButton: Button = {
            let button = Button(style: .default, size: .small, withAutoLayout: true)
            button.addTarget(self, action: #selector(markAllAsReadButtonTapped), for: .touchUpInside)
            button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return button
        }()

        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            return stackView
        }()

        // MARK: - Init

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Internal methods

        func configure(with viewModel: SavedSearchesHeaderViewModel) {
            groupSelectionView.title = viewModel.groupSelectionTitle
            markAllAsReadButton.setTitle(viewModel.markAllAsReadButtonTitle, for: .normal)
        }

        // MARK: - Private methods

        private func setup() {
            layoutMargins = UIEdgeInsets(vertical: 0, horizontal: .spacingM)

            addSubview(stackView)
            stackView.addArrangedSubview(groupSelectionView)
            stackView.addArrangedSubview(markAllAsReadButton)
            stackView.fillInSuperviewReadableArea()
        }

        @objc func markAllAsReadButtonTapped() {
            delegate?.savedSearchesHeaderViewDidSelectMarkAllAsRead(self)
        }

        @objc func groupSelectionButtonTapped() {
            delegate?.savedSearchesHeaderViewDidSelectGroupSelectionButton(self, sortingView: groupSelectionView)
        }
    }
}
