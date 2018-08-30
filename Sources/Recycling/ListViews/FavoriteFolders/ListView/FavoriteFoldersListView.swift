//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFoldersListViewDelegate: NSObjectProtocol {
    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didSelectItemAtIndex index: Int)
}

public protocol FavoriteFoldersListViewDataSource: NSObjectProtocol {
    func numberOfItems(inFavoriteFoldersListView favoriteFoldersListView: FavoriteFoldersListView) -> Int
    func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, modelAtIndex index: Int) -> FavoriteFoldersListViewModel
}

public class FavoriteFoldersListView: UIView {
    public static let estimatedRowHeight: CGFloat = 60.0

    // MARK: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteFoldersListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoriteFoldersListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    private weak var delegate: FavoriteFoldersListViewDelegate?
    private weak var dataSource: FavoriteFoldersListViewDataSource?

    // MARK: - Setup

    public init(delegate: FavoriteFoldersListViewDelegate, dataSource: FavoriteFoldersListViewDataSource) {
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
        tableView.register(FavoriteFoldersListViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UICollectionViewDelegate

extension FavoriteFoldersListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoriteFoldersListView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension FavoriteFoldersListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inFavoriteFoldersListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteFoldersListViewCell.self, for: indexPath)
        if let model = dataSource?.favoriteFoldersListView(self, modelAtIndex: indexPath.row) {
            cell.model = model
        }

        return cell
    }
}
