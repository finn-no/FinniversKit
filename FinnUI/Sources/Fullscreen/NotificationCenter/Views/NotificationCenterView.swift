//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterViewDataSource: AnyObject {
    func numberOfSegments(in view: NotificationCenterView) -> Int
    func notificationCenterView(_ view: NotificationCenterView, titleInSegment segment: Int) -> String
    func notificationCenterView(_ view: NotificationCenterView, numberOfSectionsInSegment segment: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, numberOfRowsInSection section: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForCellAt indexPath: IndexPath) -> NotificationCenterCellType
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, timestampForCellAt indexPath: IndexPath) -> String?
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForHeaderInSection section: Int) -> NotificationCenterHeaderViewModel
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, overflowInSection section: Int) -> Bool
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, titleForFooterInSection section: Int) -> String
}

public protocol NotificationCenterViewDelegate: AnyObject {
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectModelAt indexPath: IndexPath)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectSavedSearchButtonIn section: Int)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectFooterButtonInSection section: Int)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didPullToRefreshUsing refreshControl: UIRefreshControl)
}

final public class NotificationCenterView: UIView {

    // MARK: - Public properties

    public weak var dataSource: NotificationCenterViewDataSource?
    public weak var delegate: NotificationCenterViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    public var selectedSegment: Int = 0 {
        didSet { segmentedControl.selectedSegmentIndex = selectedSegment }
    }

    // MARK: - Private properties

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(withAutoLayout: true)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private var segmentContainers: [SegmentContainer]?
    private var reloadOnEndDragging = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        if segmentContainers == nil {
            setupSegmentedControl()
        }

        super.layoutSubviews()
    }
}

// MARK: - Public Methods
public extension NotificationCenterView {
    func reloadData() {
        segmentedControl.removeAllSegments()
        segmentContainers?.forEach { $0.tableView.removeFromSuperview() }
        setupSegmentedControl()
    }

    func reloadRows(at indexPaths: [IndexPath], inSegment segment: Int) {
        guard let segmentContainers = segmentContainers, segmentContainers.indices ~= segment else { return }
        segmentContainers[segment].tableView.reloadRows(at: indexPaths, with: .automatic)
    }

    func indexPathForSelectedRow(inSegment segment: Int) -> IndexPath? {
        guard let segmentContainers = segmentContainers, segmentContainers.indices ~= segment else { return nil }
        return segmentContainers[segment].tableView.indexPathForSelectedRow
    }

    func resetContentOffset() {
        segmentContainers?[selectedSegment].tableView.setContentOffset(CGPoint(x: 0, y: -.spacingM), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NotificationCenterView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.notificationCenterView(self, numberOfSectionsInSegment: selectedSegment) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.notificationCenterView(self, segment: selectedSegment, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = dataSource?.notificationCenterView(self, segment: selectedSegment, modelForCellAt: indexPath)
        let timestamp = dataSource?.notificationCenterView(self, segment: selectedSegment, timestampForCellAt: indexPath)
        let overflow = dataSource?.notificationCenterView(self, segment: selectedSegment, overflowInSection: indexPath.section) ?? false
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

        switch cellType {
        case let .notificationCell(model):
            let cell = tableView.dequeue(NotificationCell.self, for: indexPath)
            cell.remoteImageViewDataSource = remoteImageViewDataSource
            cell.configure(with: model, timestamp: timestamp, hideSeparator: isLast, showGradient: isLast && overflow)
            return cell
        case let .feedbackCell(delegate, state, model):
            let cell = tableView.dequeue(FeedbackCell.self, for: indexPath)
            cell.delegate = delegate
            cell.configure(for: state, with: model)
            return cell
        case .none:
            fatalError("Cell type not specified")
        }
    }
}

// MARK: - UITableViewDelegate
extension NotificationCenterView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.notificationCenterView(self, segment: selectedSegment, didSelectModelAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerViewModel = dataSource?.notificationCenterView(self, segment: selectedSegment, modelForHeaderInSection: section) else {
            return nil
        }

        let headerView = tableView.dequeue(NotificationCenterHeaderView.self)
        headerView.delegate = self
        headerView.configure(with: headerViewModel, inSection: section)
        return headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard dataSource?.notificationCenterView(self, segment: selectedSegment, overflowInSection: section) == true else {
            return nil
        }

        let title = dataSource?.notificationCenterView(self, segment: selectedSegment, titleForFooterInSection: section)
        let footerView = tableView.dequeue(NotificationCenterFooterView.self)
        footerView.delegate = self
        footerView.configure(with: title, inSection: section)
        return footerView
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard reloadOnEndDragging, let refreshControl = scrollView.refreshControl else { return }
        reloadOnEndDragging = false
        delegate?.notificationCenterView(self, segment: selectedSegment, didPullToRefreshUsing: refreshControl)
    }
}

// MARK: - NotificationCenterHeaderViewDelegate
extension NotificationCenterView: NotificationCenterHeaderViewDelegate {
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectSavedSearchButtonInSection section: Int) {
        delegate?.notificationCenterView(self, segment: selectedSegment, didSelectSavedSearchButtonIn: section)
    }
}

// MARK: - NotificationCenterFooterViewDelegate
extension NotificationCenterView: NotificationCenterFooterViewDelegate {
    func notificationCenterSectionFooterView(_ footerView: NotificationCenterFooterView, didSelectButtonIn section: Int) {
        delegate?.notificationCenterView(self, segment: selectedSegment, didSelectFooterButtonInSection: section)
    }
}

// MARK: - Private Methods
private extension NotificationCenterView {
    func setup() {
        addSubview(segmentedControl)
        addSubview(separatorLine)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .spacingM),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    @objc func handleRefreshBegan() {
        reloadOnEndDragging = true
    }

    func setupSegmentedControl() {
        segmentContainers = []

        guard let dataSource = dataSource else {
            return
        }

        for segment in 0 ..< dataSource.numberOfSegments(in: self) {
            let title = dataSource.notificationCenterView(self, titleInSegment: segment)
            let tableView = UITableView.createNotificationCenterTableView()
            let refreshControl = UIRefreshControl(frame: .zero)
            refreshControl.addTarget(self, action: #selector(handleRefreshBegan), for: .valueChanged)
            tableView.refreshControl = refreshControl
            tableView.dataSource = self
            tableView.delegate = self

            let container = SegmentContainer(
                title: title,
                tableView: tableView,
                leadingConstraint: tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
            )

            segmentContainers?.append(container)
            segmentedControl.insertSegment(withTitle: title, at: segment, animated: false)
        }

        segmentedControl.selectedSegmentIndex = selectedSegment
        transitionBetweenSegments(from: nil, to: selectedSegment, animated: false)
    }

    @objc func handleSegmentChange() {
        let previousSegmentIndex = selectedSegment
        selectedSegment = segmentedControl.selectedSegmentIndex
        transitionBetweenSegments(from: previousSegmentIndex, to: segmentedControl.selectedSegmentIndex)
    }

    func transitionBetweenSegments(from: Int?, to: Int, animated: Bool = true) {
        guard let segmentContainers = segmentContainers else { return }

        let offset: CGFloat
        let currentSegmentContainer: SegmentContainer?

        if let from = from {
            let deltaIndex = CGFloat(to - from)
            offset = deltaIndex / abs(deltaIndex) * 64
            currentSegmentContainer = segmentContainers[from]
            currentSegmentContainer?.tableView.stopScrolling()
        } else {
            offset = 0
            currentSegmentContainer = nil
        }

        let nextSegmentContainer = segmentContainers[to]
        nextSegmentContainer.tableView.alpha = 0
        nextSegmentContainer.leadingConstraint.constant = offset
        addSubview(nextSegmentContainer.tableView)

        NSLayoutConstraint.activate([
            nextSegmentContainer.leadingConstraint,
            nextSegmentContainer.tableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            nextSegmentContainer.tableView.widthAnchor.constraint(equalTo: widthAnchor),
            nextSegmentContainer.tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        layoutIfNeeded()

        nextSegmentContainer.leadingConstraint.constant = 0
        currentSegmentContainer?.leadingConstraint.constant = -offset

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: animated ? 0.15 : 0,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                currentSegmentContainer?.tableView.alpha = 0
                nextSegmentContainer.tableView.alpha = 1
                self.layoutIfNeeded()
            },
            completion: { _ in
                currentSegmentContainer?.tableView.removeFromSuperview()
            }
        )
    }
}

// MARK: - Private class
private class SegmentContainer {
    let title: String
    let tableView: UITableView
    let leadingConstraint: NSLayoutConstraint

    init(
        title: String,
        tableView: UITableView,
        leadingConstraint: NSLayoutConstraint
    ) {
        self.title = title
        self.tableView = tableView
        self.leadingConstraint = leadingConstraint
    }
}

// MARK: - UITableView
private extension UITableView {
    static func createNotificationCenterTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .bgPrimary
        tableView.estimatedRowHeight = 150
        tableView.estimatedSectionHeaderHeight = 48
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: .spacingM, leading: 0, bottom: 0, trailing: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -.spacingM)
        tableView.register(NotificationCell.self)
        tableView.register(FeedbackCell.self)
        tableView.register(NotificationCenterHeaderView.self)
        tableView.register(NotificationCenterFooterView.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}
