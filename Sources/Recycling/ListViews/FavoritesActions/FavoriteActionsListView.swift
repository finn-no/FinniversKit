//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteActionsListViewDelegate: AnyObject {
    func favoriteFoldersListView(_ view: FavoriteActionsListView, didSelectItemAtIndex index: Int)
}

public protocol FavoriteActionsListViewDataSource: AnyObject {
    func numberOfItems(inFavoriteActionsListView view: FavoriteActionsListView) -> Int
    func favoriteActionsListView(_ view: FavoriteActionsListView, viewModelAtIndex index: Int) -> FavoriteActionViewModel
}

public final class FavoriteActionsListView: UIView {
    public static let estimatedRowHeight: CGFloat = 48.0

    // MARK: - Public properties

    public weak var delegate: FavoriteActionsListViewDelegate?
    public weak var dataSource: FavoriteActionsListViewDataSource?

    // MARK: - Private properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteActionsListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoriteActionsListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteActionsListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inFavoriteActionsListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)

        if let viewModel = dataSource?.favoriteActionsListView(self, viewModelAtIndex: indexPath.row) {
            
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteActionsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
