//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFoldersListViewDelegate: class {
    func favoriteFoldersListView(_ view: FavoriteFoldersListView, didSelectItemAtIndex index: Int)
}

public protocol FavoriteFoldersListViewDataSource: RemoteImageTableViewCellDataSource {
    func numberOfItems(inFavoriteFoldersListView view: FavoriteFoldersListView) -> Int

    func favoriteFoldersListView(
        _ view: FavoriteFoldersListView,
        viewModelAtIndex index: Int
    ) -> FavoriteFoldersListViewModel
}

public class FavoriteFoldersListView: UIView {
    public static let estimatedRowHeight: CGFloat = 64.0

    // MARK: - Public properties

    public weak var delegate: FavoriteFoldersListViewDelegate?
    public weak var dataSource: FavoriteFoldersListViewDataSource?

    // MARK: - Private properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteFoldersListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoriteFoldersListView.estimatedRowHeight
        tableView.separatorInset = .leadingInset(frame.width)
        tableView.register(RemoteImageTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDelegate

extension FavoriteFoldersListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoriteFoldersListView(self, didSelectItemAtIndex: indexPath.row)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? RemoteImageTableViewCell {
            cell.loadImage()
        }

        let isLastCell = indexPath.row == (self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1)

        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoriteFoldersListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inFavoriteFoldersListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RemoteImageTableViewCell.self, for: indexPath)

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.loadingColor = color
        cell.dataSource = dataSource

        if let viewModel = dataSource?.favoriteFoldersListView(self, viewModelAtIndex: indexPath.row) {
            cell.configure(with: viewModel)
        }

        return cell
    }
}
