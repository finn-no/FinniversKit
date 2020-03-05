//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterViewDelegate: AnyObject {
    func notificationCenterView(_ view: NotificationCenterView, didSelectModelAt indexPath: IndexPath)
    func notificationCenterView(_ view: NotificationCenterView, didSelectNotificationDetailsIn section: Int)
    func notificationCenterView(_ view: NotificationCenterView, didPullToRefreshWith refreshControl: UIRefreshControl)
    func notificationCenterViewWillReachEndOfContent(_ view: NotificationCenterView)
    func notificationCenterView(_ view: NotificationCenterView, didReachEndOfContentWith activityIndicatorView: LoadingIndicatorView)
}

public protocol NotificationCenterViewDataSource: AnyObject {
    func numberOfSections(in view: NotificationCenterView) -> Int
    func notificationCenterView(_ view: NotificationCenterView, numberOfRowsIn section: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, modelForSection section: Int) -> NotificationCenterSectionHeaderViewModel
    func notificationCenterView(_ view: NotificationCenterView, modelForRowAt indexPath: IndexPath) -> NotificationCenterCellModel
    func notificationCenterView(_ view: NotificationCenterView, timestampForModelAt indexPath: IndexPath) -> String?
}

public class NotificationCenterView: UIView {

    public weak var delegate: NotificationCenterViewDelegate?
    public weak var dataSource: NotificationCenterViewDataSource?
    public weak var imageViewDataSource: RemoteImageViewDataSource?

    // MARK: - Private properties

    private var refreshOnPanEnded = false

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = RefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(handleRefresh(control:)), for: .valueChanged)
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .bgPrimary
        tableView.estimatedRowHeight = 150
        tableView.estimatedSectionHeaderHeight = 48
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

        cell.configure(
            with: model,
            timestamp: dataSource?.notificationCenterView(self, timestampForModelAt: indexPath),
            hideSeparator: isLastCell
        )

        return cell
    }
}

extension NotificationCenterView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.notificationCenterView(self, didSelectModelAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.isLastPath(in: tableView) {
            delegate?.notificationCenterViewWillReachEndOfContent(self)
        }
    }

    // Header

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = dataSource?.notificationCenterView(self, modelForSection: section) else { return nil }
        let header = tableView.dequeue(NotificationCenterSectionHeaderView.self)
        header.delegate = self
        header.configure(with: model, inSection: section)
        return header
    }

    // Footer

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section.isLastSection(in: tableView) else { return nil }
        return tableView.dequeue(ActivityIndicatorSectionFooterView.self)
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section.isLastSection(in: tableView) else { return .leastNormalMagnitude }
        return .spacingXXL
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard section.isLastSection(in: tableView) else { return }
        guard let footerView = view as? ActivityIndicatorSectionFooterView else { return }
        delegate?.notificationCenterView(self, didReachEndOfContentWith: footerView.activityIndicatorView)
    }
}

extension NotificationCenterView: NotificationCenterSectionHeaderViewDelegate {
    func notificationCenterSectionHeaderView(_ headerView: NotificationCenterSectionHeaderView, didSelectNotificationDetailsInSection section: Int) {
        delegate?.notificationCenterView(self, didSelectNotificationDetailsIn: section)
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

private extension Int {
    func isLastSection(in tableView: UITableView) -> Bool {
        self == tableView.numberOfSections - 1
    }
}

private extension IndexPath {
    func isLastPath(in tableView: UITableView) -> Bool {
        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        return section == lastSection && row == lastRow
    }
}
