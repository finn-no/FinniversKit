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
    private enum Section: Int, CaseIterable {
        case addButton
        case folder
    }

    public static let estimatedRowHeight: CGFloat = 64.0

    // MARK: - Public properties

    public weak var delegate: FavoriteFoldersListViewDelegate?
    public weak var dataSource: FavoriteFoldersListViewDataSource?

    // MARK: - Private properties

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(withAutoLayout: true)
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .milk
        searchBar.placeholder = "Søk etter en av dine lister"
        //searchBar.delegate = self
        return searchBar
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

    private lazy var topShadowView = ShadowView(withAutoLayout: true)

    private lazy var bottomShadowView: UIView = {
        let view = FavoriteAddFolderView(withAutoLayout: true)
        view.configure(withTitle: "Lag ny liste")
        return view
    }()

    private lazy var bottomShadowViewTop = bottomShadowView.topAnchor.constraint(
        equalTo: bottomAnchor,
        constant: FavoriteFoldersListView.estimatedRowHeight
    )

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
        addSubview(topShadowView)
        addSubview(searchBar)
        addSubview(bottomShadowView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            topShadowView.topAnchor.constraint(equalTo: topAnchor, constant: -44),
            topShadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topShadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topShadowView.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            bottomShadowViewTop,
            bottomShadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomShadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomShadowView.heightAnchor.constraint(equalToConstant: 56)
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
            cell.configure(withTitle: "Lag ny liste")
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
        topShadowView.update(with: scrollView)

        let viewHeight = bottomShadowView.frame.height
        let offsetY = scrollView.contentOffset.y

        if offsetY >= 0 && offsetY <= viewHeight * 2 {
            bottomShadowViewTop.constant = -offsetY + viewHeight
        }
    }
}

private class FreeTextFilterSearchBar: UISearchBar {
    // Makes sure to setup appearance proxy one time and one time only
//    private static let setupSearchQuerySearchBarAppereanceOnce: () = {
//        let textFieldAppearance = UITextField.appearance(whenContainedInInstancesOf: [FreeTextFilterSearchBar.self])
//        textFieldAppearance.adjustsFontForContentSizeCategory = true
//        textFieldAppearance.defaultTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.licorice,
//            NSAttributedString.Key.font: UIFont.bodyRegular,
//        ]
//
//        let barButtondAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [FreeTextFilterSearchBar.self])
//        barButtondAppearance.setTitleTextAttributes([.font: UIFont.bodyRegular])
//        barButtondAppearance.title = "cancel".localized()
//    }()
//
//    override init(frame: CGRect) {
//        _ = FreeTextFilterSearchBar.setupSearchQuerySearchBarAppereanceOnce
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        _ = FreeTextFilterSearchBar.setupSearchQuerySearchBarAppereanceOnce
//        super.init(coder: aDecoder)
//    }
}
