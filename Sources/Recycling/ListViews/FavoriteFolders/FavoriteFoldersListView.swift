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
    ) -> FavoriteFolderViewModel
}

public class FavoriteFoldersListView: UIView {
    private enum Section: Int, CaseIterable {
        case addButton
        case folder
    }

    public static let estimatedRowHeight: CGFloat = 64.0

    // MARK: - Public properties

    public weak var delegate: FavoriteFoldersListViewDelegate?
    public weak var dataSource: FavoriteFoldersListViewDataSource?

    // MARK: - Private properties

    private let viewModel: FavoriteFoldersListViewModel

    private(set) lazy var searchBar: FavoriteFoldersSearchBar = {
        let view = FavoriteFoldersSearchBar(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteFoldersListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoriteFoldersListView.estimatedRowHeight
        tableView.separatorInset = .leadingInset(frame.width)
        tableView.tableFooterView = UIView()
        tableView.register(FavoriteAddFolderViewCell.self)
        tableView.register(RemoteImageTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var footerView = FavoriteAddFolderView(withAutoLayout: true)
    private lazy var footerViewTop = footerView.topAnchor.constraint(
        equalTo: bottomAnchor, constant: FavoriteFoldersListView.estimatedRowHeight
    )

    // MARK: - Init

    public required init(viewModel: FavoriteFoldersListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init

    private func setup() {
        searchBar.configure(withPlaceholder: viewModel.searchBarPlaceholder)
        footerView.configure(withTitle: viewModel.addFolderText)

        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [FavoriteFoldersSearchBar.self])
        barButtonAppearance.title = viewModel.cancelButtonTitle

        addSubview(tableView)
        addSubview(searchBar)
        addSubview(footerView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            footerViewTop,
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 56)
        ])
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
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .addButton:
            return 1
        case .folder:
            return dataSource?.numberOfItems(inFavoriteFoldersListView: self) ?? 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .addButton:
            let cell = tableView.dequeue(FavoriteAddFolderViewCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.addFolderText)
            return cell
        case .folder:
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
}

extension FavoriteFoldersListView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.updateShadow(using: scrollView)

        let viewHeight = footerView.frame.height
        let offsetY = scrollView.contentOffset.y

        if offsetY >= 0 && offsetY <= viewHeight * 2 {
            footerViewTop.constant = -offsetY + viewHeight
            tableView.contentInset.bottom = -footerViewTop.constant
        }
    }
}

// MARK: - UISearchBarDelegate

extension FavoriteFoldersListView: UISearchBarDelegate {

}
