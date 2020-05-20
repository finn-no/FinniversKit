//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterSearchViewDataSource: AnyObject {
    func notificationCenterSearchView(_ view: NotificationCenterSearchView, numberOfRowsInSection section: Int) -> Int
    func notificationCenterSearchView(_ view: NotificationCenterSearchView, modelForCellAt indexPath: IndexPath) -> NotificationCellModel
    func notificationCenterSearchView(_ view: NotificationCenterSearchView, timestampForCellAt indexPath: IndexPath) -> String?
    func notificationCenterSearchView(_ view: NotificationCenterSearchView, modelForHeaderInSection section: Int) -> NotificationCenterSearchViewModel
}

public protocol NotificationCenterSearchViewDelegate: AnyObject {
    func notificationCenterSearchViewDidSelectShowEntireSearch(_ view: NotificationCenterSearchView)
    func notificationCenterSearchView(_ view: NotificationCenterSearchView, didSelectModelAt indexPath: IndexPath)
}

public struct NotificationCenterSearchViewModel {
    public let title: String
    public let rowCountText: String
    public let searchButtonTitle: String

    public init(title: String, rowCountText: String, searchButtonTitle: String) {
        self.title = title
        self.rowCountText = rowCountText
        self.searchButtonTitle = searchButtonTitle
    }
}

public final class NotificationCenterSearchView: UIView {

    public weak var dataSource: NotificationCenterSearchViewDataSource?
    public weak var delegate: NotificationCenterSearchViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.separatorStyle = .none
        tableView.register(NotificationCell.self)
        tableView.register(TableViewHeaderView.self)
        return tableView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        tableView.reloadData()
    }

    public func reloadSelectedRow() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension NotificationCenterSearchView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.notificationCenterSearchView(self, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource?.notificationCenterSearchView(self, modelForCellAt: indexPath)
        let timestamp = dataSource?.notificationCenterSearchView(self, timestampForCellAt: indexPath)
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

        let cell = tableView.dequeue(NotificationCell.self, for: indexPath)
        cell.remoteImageViewDataSource = remoteImageViewDataSource
        cell.configure(with: model, timestamp: timestamp, hideSeparator: isLast, showGradient: false)
        return cell
    }
}

extension NotificationCenterSearchView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.notificationCenterSearchView(self, didSelectModelAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource?.notificationCenterSearchView(self, modelForHeaderInSection: section)
        let headerView = tableView.dequeue(TableViewHeaderView.self)
        headerView.delegate = self
        headerView.configure(with: model)
        return headerView
    }
}

extension NotificationCenterSearchView: TableViewHeaderViewDelegate {
    fileprivate func tableViewHeaderViewDidSelectShowEntireSearchButton(_ view: TableViewHeaderView) {
        delegate?.notificationCenterSearchViewDidSelectShowEntireSearch(self)
    }
}

private protocol TableViewHeaderViewDelegate: AnyObject {
    func tableViewHeaderViewDidSelectShowEntireSearchButton(_ view: TableViewHeaderView)
}

private class TableViewHeaderView: UITableViewHeaderFooterView {

    weak var delegate: TableViewHeaderViewDelegate?

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var rowCountLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private lazy var showSearchButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSearchButtonSelected), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, rowCountLabel, showSearchButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(.spacingS, after: rowCountLabel)
        return stackView
    }()

    private lazy var colorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .bgPrimary
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView = colorView
        contentView.addSubview(stackView)
        stackView.fillInSuperview(margin: .spacingM)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleSearchButtonSelected() {
        delegate?.tableViewHeaderViewDidSelectShowEntireSearchButton(self)
    }

    func configure(with model: NotificationCenterSearchViewModel?) {
        titleLabel.text = model?.title
        rowCountLabel.text = model?.rowCountText
        showSearchButton.setTitle(model?.searchButtonTitle, for: .normal)
    }
}
