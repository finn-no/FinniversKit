//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteActionViewDelegate: AnyObject {
    func favoriteActionView(_ view: FavoriteActionView, didSelectAction action: FavoriteAction)
}

public final class FavoriteActionView: UIView {
    public static let rowHeight: CGFloat = 48.0
    public static let totalHeight = rowHeight * CGFloat(FavoriteSortOption.allCases.count)

    // MARK: - Public properties

    public weak var delegate: FavoriteActionViewDelegate?

    // MARK: - Private properties

    private let viewModel: FavoriteActionViewModel
    private let actions = FavoriteAction.allCases

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteSortingView.rowHeight
        tableView.estimatedRowHeight = FavoriteSortingView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(FavoriteFolderActionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteActionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDataSource

extension FavoriteActionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteFolderActionCell.self, for: indexPath)

        switch actions[indexPath.row] {
        case .addNote:
            cell.configure(withTitle: viewModel.addNoteText, icon: .favoritesNote)
        case .delete:
            cell.configure(withTitle: viewModel.deleteText, icon: .favoritesDelete, tintColor: .cherry)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteActionView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        delegate?.favoriteActionView(self, didSelectAction: action)
    }
}
