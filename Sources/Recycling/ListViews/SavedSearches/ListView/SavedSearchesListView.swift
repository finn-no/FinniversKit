//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SavedSearchesListViewDelegate: AnyObject {
    func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, didSelectItemAtIndex index: Int)
}

public protocol SavedSearchesListViewDataSource: AnyObject {
    func numberOfItems(inSavedSearchesListView savedSearchesListView: SavedSearchesListView) -> Int
    func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, modelAtIndex index: Int) -> SavedSearchesListViewModel
}

public class SavedSearchesListView: UIView {
    public static let estimatedRowHeight: CGFloat = 60.0

    // MARK: - Internal properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = SavedSearchesListView.estimatedRowHeight
        tableView.estimatedRowHeight = SavedSearchesListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .sardine
        return tableView
    }()

    private weak var delegate: SavedSearchesListViewDelegate?
    private weak var dataSource: SavedSearchesListViewDataSource?

    // MARK: - Setup

    public init(frame: CGRect = .zero, delegate: SavedSearchesListViewDelegate, dataSource: SavedSearchesListViewDataSource) {
        super.init(frame: frame)

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
        tableView.register(SavedSearchesListViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDelegate

extension SavedSearchesListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.savedSearchesListView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension SavedSearchesListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inSavedSearchesListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SavedSearchesListViewCell.self, for: indexPath)

        if let model = dataSource?.savedSearchesListView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}
