//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol NotificationsListViewDelegate: NSObjectProtocol {
    func notificationsListView(_ notificationsListView: NotificationsListView, didSelectItemAtIndexPath indexPath: IndexPath)
    func notificationsListView(_ notificationsListView: NotificationsListView, willDisplayItemAtIndexPath indexPath: IndexPath)
    func notificationsListView(_ notificationsListView: NotificationsListView, didScrollInScrollView scrollView: UIScrollView)
    func notificationsListView(_ notificationsListView: NotificationsListView, titleForHeaderInSection section: Int) -> String?
    func notificationsListView(_ notificationsListView: NotificationsListView, titleForFooterInSection section: Int) -> String?
}

public protocol NotificationsListViewDataSource: NSObjectProtocol {
    func numberOfSections(inNotificationsListView notificationsListView: NotificationsListView) -> Int
    func notificationsListView(_ notificationsListView: NotificationsListView, numberOfItemsInSection section: Int) -> Int
    func notificationsListView(_ notificationsListView: NotificationsListView, modelAtIndexPath indexPath: IndexPath) -> NotificationsListViewModel
    func notificationsListView(_ notificationsListView: NotificationsListView, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func notificationsListView(_ notificationsListView: NotificationsListView, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat)
}

public class NotificationsListView: UIView {

    // MARK: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = NotificationsListViewCell.cellHeight
        tableView.estimatedRowHeight = NotificationsListViewCell.cellHeight
        return tableView
    }()

    private weak var delegate: NotificationsListViewDelegate?
    private weak var dataSource: NotificationsListViewDataSource?

    // MARK: - Setup

    public init(delegate: NotificationsListViewDelegate, dataSource: NotificationsListViewDataSource) {
        super.init(frame: .zero)

        self.delegate = delegate
        self.dataSource = dataSource

        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        tableView.register(NotificationsListViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Public

    public func reloadData() {
        tableView.reloadData()
    }

    public func scrollToTop(animated: Bool = true) {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension NotificationsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.notificationsListView(self, didSelectItemAtIndexPath: indexPath)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.notificationsListView(self, didScrollInScrollView: scrollView)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate?.notificationsListView(self, titleForHeaderInSection: section)
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return delegate?.notificationsListView(self, titleForFooterInSection: section)
    }
}

// MARK: - UICollectionViewDataSource

extension NotificationsListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(inNotificationsListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.notificationsListView(self, numberOfItemsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationsListViewCell.self, for: indexPath)

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.loadingColor = color
        cell.dataSource = self

        if let model = dataSource?.notificationsListView(self, modelAtIndexPath: indexPath) {
            cell.model = model
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NotificationsListViewCell {
            cell.loadImage()
        }

        delegate?.notificationsListView(self, willDisplayItemAtIndexPath: indexPath)
    }
}

// MARK: - NotificationsListViewCellDataSource

extension NotificationsListView: NotificationsListViewCellDataSource {
    public func notificationsListViewCell(_ notificationsListViewCell: NotificationsListViewCell, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.notificationsListView(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func notificationsListViewCell(_ notificationsListViewCell: NotificationsListViewCell, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat) {
        dataSource?.notificationsListView(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}
