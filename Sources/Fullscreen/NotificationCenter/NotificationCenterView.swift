//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterViewDelegate: AnyObject {
    func notificationCenterView(_ view: NotificationCenterView, didSelectModelAt indexPath: IndexPath)
    func notificationCenterView(_ view: NotificationCenterView, didSelectDetailsAt indexPath: IndexPath)
    func notificationCenterView(_ view: NotificationCenterView, titleForSection section: Int) -> String
    func notificationCenterView(_ view: NotificationCenterView, timestampForModelAt indexPath: IndexPath) -> String?
    func notificationCenterView(_ view: NotificationCenterView, didPullToRefreshWith refreshControl: UIRefreshControl)
    func notificationCenterViewWillReachEndOfContent(_ view: NotificationCenterView)
    func notificationCenterViewDidReachEndOfContent(_ view: NotificationCenterView)
}

public protocol NotificationCenterViewDataSource: AnyObject {
    func numberOfSections(in view: NotificationCenterView) -> Int
    func notificationCenterView(_ view: NotificationCenterView, numberOfRowsIn section: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, modelForRowAt indexPath: IndexPath) -> NotificationCenterCellModel
}

public class NotificationCenterView: UIView {

    public weak var delegate: NotificationCenterViewDelegate?
    public weak var dataSource: NotificationCenterViewDataSource?
    public weak var imageViewDataSource: RemoteImageViewDataSource?

    // MARK: - Private properties

    private var refreshOnPanEnded = false

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(control:)), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .bgPrimary
        tableView.estimatedRowHeight = 150
        tableView.estimatedSectionHeaderHeight = 32
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(NotificationCenterCell.self)
        tableView.register(NotificationCenterSectionHeaderView.self)
        tableView.register(ActivityIndicatorSectionFooterView.self)
        tableView.refreshControl = refreshControl
        tableView.panGestureRecognizer.addTarget(self, action: #selector(handleTableViewPan(gesture:)))
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
}

public extension NotificationCenterView {
    var indexPathForSelectedRow: IndexPath? {
        tableView.indexPathForSelectedRow
    }

    func reloadData() {
        tableView.reloadData()
    }

    func reloadRows(at indexPaths: [IndexPath], animated: Bool = true) {
        tableView.reloadRows(at: indexPaths, with: animated ? .automatic : .none)
    }

    func resetContentOffset() {
        guard tableView.numberOfRows(inSection: 0) > 0 else { return }

        tableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top,
            animated: true
        )
    }
}

extension NotificationCenterView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.numberOfSections(in: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.notificationCenterView(self, numberOfRowsIn: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource?.notificationCenterView(self, modelForRowAt: indexPath)
        let cell = tableView.dequeue(NotificationCenterCell.self, for: indexPath)
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

        cell.imageViewDataSource = imageViewDataSource
        cell.delegate = self

        cell.configure(
            with: model,
            timestamp: delegate?.notificationCenterView(self, timestampForModelAt: indexPath),
            hideSeparator: isLastCell
        )

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = .leadingInset(.greatestFiniteMagnitude)
        }

        return cell
    }
}

extension NotificationCenterView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.notificationCenterView(self, didSelectModelAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1

        if indexPath.section == lastSection, indexPath.row == lastRow {
            delegate?.notificationCenterViewWillReachEndOfContent(self)
        }
    }

    // Header

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = delegate?.notificationCenterView(self, titleForSection: section) else { return nil }
        let header = tableView.dequeue(NotificationCenterSectionHeaderView.self)
        header.configure(with: title)
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }

    // Footer

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == tableView.numberOfSections - 1 else { return nil }
        return tableView.dequeue(ActivityIndicatorSectionFooterView.self)
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == tableView.numberOfSections - 1 else { return .leastNormalMagnitude }
        return .veryLargeSpacing
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard section == tableView.numberOfSections - 1 else { return }
        guard let activityIndicatorView = view as? ActivityIndicatorSectionFooterView else { return }
        activityIndicatorView.startAnimating()
        delegate?.notificationCenterViewDidReachEndOfContent(self)
    }
}

extension NotificationCenterView: NotificationCenterCellDelegate {
    func notificationCenterCellDidSelectSavedSearch(_ cell: NotificationCenterCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.notificationCenterView(self, didSelectDetailsAt: indexPath)
    }
}

private extension NotificationCenterView {
    @objc func handleTableViewPan(gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended, refreshOnPanEnded else { return }
        refreshOnPanEnded = false
        delegate?.notificationCenterView(self, didPullToRefreshWith: refreshControl)
    }

    @objc func handleRefresh(control: UIRefreshControl) {
        refreshOnPanEnded = true
    }
}
