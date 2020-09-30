//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCenterViewDataSource: AnyObject {
    func numberOfSegments(in view: NotificationCenterView) -> Int
    func notificationCenterView(_ view: NotificationCenterView, titleInSegment segment: Int) -> String
    func notificationCenterView(_ view: NotificationCenterView, includeHeaderIn segment: Int) -> Bool
    func notificationCenterView(_ view: NotificationCenterView, numberOfSectionsInSegment segment: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, numberOfRowsInSection section: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForCellAt indexPath: IndexPath) -> NotificationCenterCellType
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, timestampForCellAt indexPath: IndexPath) -> String?
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForHeaderInSection section: Int) -> NotificationCenterHeaderViewModel
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, overflowInSection section: Int) -> Bool
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, titleForFooterInSection section: Int) -> String
    func notificationCenterView(_ view: NotificationCenterView, fetchNextPageFor segment: Int)
}

public protocol NotificationCenterViewDelegate: AnyObject {
    func notificationCenterView(_ view: NotificationCenterView, didChangeToSegment segment: Int)
    func notificationCenterView(_ view: NotificationCenterView, didSelectMarkAllAsReadButtonIn segment: Int)
    func notificationCenterView(_ view: NotificationCenterView, didSelectShowGroupOptions segment: Int, sortingView: UIView)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectModelAt indexPath: IndexPath)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectSavedSearchButtonIn section: Int)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectMoreButtonIn section: Int)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectFooterButtonInSection section: Int)
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didPullToRefreshUsing refreshControl: UIRefreshControl)
}

final public class NotificationCenterView: UIView {

    // MARK: - Public properties

    public weak var dataSource: NotificationCenterViewDataSource?
    public weak var delegate: NotificationCenterViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    /// Only for saved searches notifications when presenting them in a chronological fashion
    public var isFetchingNextPageForSavedSearches: Bool = false

    public var selectedSegment: Int = 0 {
        didSet { segmentedControl.selectedSegmentIndex = selectedSegment }
    }

    public var savedSearchGroupTitle: String? {
        get { savedSearchesHeaderView.groupSelectionTitle }
        set {
            if let newValue = newValue {
                savedSearchesHeaderView.groupSelectionTitle = newValue
            }
        }
    }

    public var savedSearchesAllRead: Bool = false {
        didSet {
            savedSearchesHeaderView.markAllAsReadButton.alpha = savedSearchesAllRead ? 0 : 1
        }
    }

    public var isSavedSearchGroupingEnabled: Bool = true {
        didSet {
            savedSearchesHeaderView.groupSelectionView.alpha = isSavedSearchGroupingEnabled ? 1 : 0
        }
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

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var savedSearchesHeaderView: SavedSearchesHeaderView = {
        let tableHeader = SavedSearchesHeaderView(withAutoLayout: true)
        tableHeader.configure(
            with: .init(
                groupSelectionTitle: "",
                markAllAsReadButtonTitle: markAllAsReadButtonTitle
            )
        )

        tableHeader.delegate = self
        return tableHeader
    }()

    private lazy var groupingCalloutView: CalloutView = {
        let view = CalloutView(direction: .up, arrowAlignment: .left(20))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()

    private var segmentTitles: [String]?
    private var tableViews: [UITableView]?
    private var reloadOnEndDragging = false
    private let segmentSpacing: CGFloat = .spacingS
    private let markAllAsReadButtonTitle: String

    // MARK: - Init

    public init(markAllAsReadButtonTitle: String) {
        self.markAllAsReadButtonTitle = markAllAsReadButtonTitle
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
public extension NotificationCenterView {
    func reloadData() {
        if let tableViews = tableViews {
            tableViews.forEach { $0.reloadData() }
        } else {
            setupSegmentedControl()
        }
        isFetchingNextPageForSavedSearches = false
    }

    func reloadRows(at indexPaths: [IndexPath], inSegment segment: Int) {
        guard let tableViews = tableViews, tableViews.indices ~= segment else { return }
        tableViews[segment].reloadRows(at: indexPaths, with: .automatic)
    }

    func indexPathForSelectedRow(inSegment segment: Int) -> IndexPath? {
        guard let tableViews = tableViews, tableViews.indices ~= segment else { return nil }
        return tableViews[segment].indexPathForSelectedRow
    }

    func resetContentOffset() {
        tableViews?[selectedSegment].setContentOffset(CGPoint(x: 0, y: -.spacingM), animated: true)
    }

    func showGroupingCallout(with text: String) {
        groupingCalloutView.alpha = 0
        groupingCalloutView.isHidden = false
        groupingCalloutView.show(withText: text)
    }
}

// MARK: - UITableViewDataSource
extension NotificationCenterView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let index = tableViews?.firstIndex(of: tableView) else { return 0 }
        return dataSource?.notificationCenterView(self, numberOfSectionsInSegment: index) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let index = tableViews?.firstIndex(of: tableView) else { return 0 }
        return dataSource?.notificationCenterView(self, segment: index, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = tableViews?.firstIndex(of: tableView) else { fatalError("Missing tableView") }

        let cellType = dataSource?.notificationCenterView(self, segment: index, modelForCellAt: indexPath)
        let timestamp = dataSource?.notificationCenterView(self, segment: index, timestampForCellAt: indexPath)
        let overflow = dataSource?.notificationCenterView(self, segment: index, overflowInSection: indexPath.section) ?? false
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

        switch cellType {
        case let .notificationCell(model):
            let cell = tableView.dequeue(NotificationCell.self, for: indexPath)
            cell.remoteImageViewDataSource = remoteImageViewDataSource
            cell.configure(with: model, timestamp: timestamp, hideSeparator: isLast, showGradient: isLast && overflow)
            return cell
        case let .emptyCell(model):
            let cell = tableView.dequeue(EmptyNotificationsCell.self, for: indexPath)
            cell.configure(with: model)
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
        guard
            let index = tableViews?.firstIndex(of: tableView),
            let headerViewModel = dataSource?.notificationCenterView(self, segment: index, modelForHeaderInSection: section),
            headerViewModel.title != nil || headerViewModel.savedSearchButtonModel != nil
        else { return nil }

        let headerView = tableView.dequeue(NotificationCenterHeaderView.self)
        headerView.delegate = self
        headerView.configure(with: headerViewModel, inSection: section)
        return headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard
            let index = tableViews?.firstIndex(of: tableView),
            dataSource?.notificationCenterView(self, segment: index, overflowInSection: section) == true
        else { return nil }

        let title = dataSource?.notificationCenterView(self, segment: index, titleForFooterInSection: section)
        let footerView = tableView.dequeue(NotificationCenterFooterView.self)
        footerView.delegate = self
        footerView.configure(with: title, inSection: section)
        return footerView
    }
}

// MARK: - UIScrollViewDelegate
extension NotificationCenterView: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else {
            return
        }

        let targetSegment = Int(targetContentOffset.pointee.x / scrollView.bounds.width)

        guard targetSegment != selectedSegment else {
            return
        }

        selectedSegment = targetSegment
        delegate?.notificationCenterView(self, didChangeToSegment: selectedSegment)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       guard
            scrollView != self.scrollView,
            reloadOnEndDragging,
            let refreshControl = scrollView.refreshControl
       else { return }

       reloadOnEndDragging = false
       delegate?.notificationCenterView(self, segment: selectedSegment, didPullToRefreshUsing: refreshControl)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        let willReachEndOfContent = offsetY > contentHeight - scrollView.frame.height * 4

        if willReachEndOfContent && !isFetchingNextPageForSavedSearches {
            dataSource?.notificationCenterView(self, fetchNextPageFor: selectedSegment)
            isFetchingNextPageForSavedSearches = true
        }
    }
}

// MARK: - NotificationCenterHeaderViewDelegate
extension NotificationCenterView: NotificationCenterHeaderViewDelegate {
    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectSavedSearchButtonInSection section: Int) {
        delegate?.notificationCenterView(self, segment: selectedSegment, didSelectSavedSearchButtonIn: section)
    }

    func notificationCenterHeaderView(_ view: NotificationCenterHeaderView, didSelectMoreButtonInSection section: Int) {
        delegate?.notificationCenterView(self, segment: selectedSegment, didSelectMoreButtonIn: section)
    }
}

// MARK: - NotificationCenterFooterViewDelegate
extension NotificationCenterView: NotificationCenterFooterViewDelegate {
    func notificationCenterSectionFooterView(_ footerView: NotificationCenterFooterView, didSelectButtonIn section: Int) {
        delegate?.notificationCenterView(self, segment: selectedSegment, didSelectFooterButtonInSection: section)
    }
}

// MARK: - NotificationCenterTableHeaderViewDelegate
extension NotificationCenterView: NotificationCenterTableHeaderViewDelegate {
    func savedSearchesHeaderViewDidSelectMarkAllAsRead(_ view: SavedSearchesHeaderView) {
        delegate?.notificationCenterView(self, didSelectMarkAllAsReadButtonIn: selectedSegment)
    }

    func savedSearchesHeaderViewDidSelectGroupSelectionButton(_ view: SavedSearchesHeaderView, sortingView: UIView) {
        delegate?.notificationCenterView(self, didSelectShowGroupOptions: selectedSegment, sortingView: sortingView)
    }
}

// MARK: - Private Methods
private extension NotificationCenterView {
    func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)

        addSubview(segmentedControl)
        addSubview(separatorLine)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: .spacingS),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            segmentedControl.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -.spacingS),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .spacingM),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            scrollView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: segmentSpacing),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc func handleRefreshBegan() {
        reloadOnEndDragging = true
    }

    func setupSegmentedControl() {
        guard let dataSource = dataSource else {
            return
        }

        segmentTitles = []
        tableViews = []

        var spacings: [CGFloat] = [0, segmentSpacing].reversed()
        var insertAnchor = scrollView.leadingAnchor

        for segment in 0 ..< dataSource.numberOfSegments(in: self) {
            let title = dataSource.notificationCenterView(self, titleInSegment: segment)
            segmentedControl.insertSegment(withTitle: title, at: segment, animated: false)
            segmentTitles?.append(title)

            let refreshControl = UIRefreshControl(frame: .zero)
            refreshControl.addTarget(self, action: #selector(handleRefreshBegan), for: .valueChanged)

            let tableView = UITableView.createNotificationCenterTableView()
            tableView.refreshControl = refreshControl
            tableView.dataSource = self
            tableView.delegate = self
            tableView.cellLayoutMarginsFollowReadableWidth = true

            tableViews?.append(tableView)
            scrollView.addSubview(tableView)

            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: insertAnchor, constant: spacings.popLast() ?? 0),
                tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                tableView.widthAnchor.constraint(equalTo: widthAnchor),
                tableView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])

            insertAnchor = tableView.trailingAnchor

            setUpTableHeaderIfNeeded(for: segment, in: tableView)
        }

        scrollView.trailingAnchor.constraint(equalTo: insertAnchor, constant: segmentSpacing).isActive = true
        segmentedControl.selectedSegmentIndex = selectedSegment

        scrollView.layoutIfNeeded()
        scrollToTableView(atIndex: selectedSegment, animated: false)
    }

    @objc func handleSegmentChange() {
        selectedSegment = segmentedControl.selectedSegmentIndex
        scrollToTableView(atIndex: selectedSegment, animated: true)
        delegate?.notificationCenterView(self, didChangeToSegment: selectedSegment)
    }

    func scrollToTableView(atIndex index: Int, animated: Bool) {
        guard let tableView = tableViews?[index] else { return }
        scrollView.setContentOffset(tableView.frame.origin, animated: animated)
    }

    /// Currently, only the saved searches section needs the table header
    func setUpTableHeaderIfNeeded(for segment: Int, in tableView: UITableView) {
        guard
            dataSource?.notificationCenterView(self, includeHeaderIn: segment) ?? false
        else { return }

        tableView.tableHeaderView = savedSearchesHeaderView
        NSLayoutConstraint.activate([
            savedSearchesHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            savedSearchesHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            savedSearchesHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            savedSearchesHeaderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        ])

        savedSearchesHeaderView.layoutIfNeeded()

        setupCalloutViewForGrouping(in: tableView)
    }

    func setupCalloutViewForGrouping(in tableView: UITableView) {
        tableView.addSubview(groupingCalloutView)

        NSLayoutConstraint.activate([
            groupingCalloutView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            groupingCalloutView.widthAnchor.constraint(equalToConstant: 240),
            groupingCalloutView.topAnchor.constraint(
                equalTo: savedSearchesHeaderView.groupSelectionView.bottomAnchor, constant: .spacingXS
            ),
        ])
    }
}

extension NotificationCenterView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !groupingCalloutView.isHidden && groupingCalloutView.alpha == 1 {
            groupingCalloutView.hide { [weak self] _ in
                self?.groupingCalloutView.isHidden = true
            }
        }

        return false
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
        tableView.register(EmptyNotificationsCell.self)
        tableView.register(FeedbackCell.self)
        tableView.register(NotificationCenterHeaderView.self)
        tableView.register(NotificationCenterFooterView.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        return tableView
    }
}
