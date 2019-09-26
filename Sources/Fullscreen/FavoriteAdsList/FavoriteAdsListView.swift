//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdsListViewDelegate: AnyObject {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButtonForItemAt indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectDeleteItemAt indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectCommentForItemAt indexPath: IndexPath)
    func favoriteAdsListViewDidSelectSortButton(_ view: FavoriteAdsListView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didChangeSearchText searchText: String)
}

public protocol FavoriteAdsListViewDataSource: AnyObject {
    func numberOfSections(inFavoriteAdsListView view: FavoriteAdsListView) -> Int
    func numberOfItems(inFavoriteAdsListView view: FavoriteAdsListView, forSection section: Int) -> Int
    func favoriteAdsListView(_ view: FavoriteAdsListView, titleForHeaderInSection section: Int) -> String?
    func favoriteAdsListView(_ view: FavoriteAdsListView, viewModelFor indexPath: IndexPath) -> FavoriteAdViewModel
    func favoriteAdsListView(_ view: FavoriteAdsListView,
                             loadImageWithPath imagePath: String,
                             imageWidth: CGFloat,
                             completion: @escaping ((UIImage?) -> Void)
    )
    func favoriteAdsListView(_ view: FavoriteAdsListView,
                             cancelLoadingImageWithPath imagePath: String,
                             imageWidth: CGFloat
    )
}

public class FavoriteAdsListView: UIView {

    // MARK: - Public properties

    public weak var delegate: FavoriteAdsListViewDelegate?
    public weak var dataSource: FavoriteAdsListViewDataSource?

    public var title = "" {
        didSet { tableHeaderView.title = title }
    }

    public var subtitle = "" {
        didSet { tableHeaderView.subtitle = subtitle }
    }

    public var searchBarText: String {
        get { return tableHeaderView.searchBarText }
        set { tableHeaderView.searchBarText = newValue }
    }

    public var sortingTitle: String = "" {
        didSet { tableHeaderView.sortingTitle = sortingTitle }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteAdsListViewModel
    private let imageCache = ImageMemoryCache()
    private var didSetTableHeader = false
    private var tableViewConstraints = [NSLayoutConstraint]()
    private var emptyViewConstraints = [NSLayoutConstraint]()

    private lazy var tableView: UITableView = {
        let tableView = TableView(withAutoLayout: true)
        tableView.register(FavoriteAdTableViewCell.self)
        tableView.register(FavoriteAdsSectionHeaderView.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .leadingInset(frame.width)
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 130
        tableView.estimatedSectionHeaderHeight = 32
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()

    private lazy var tableHeaderView: FavoriteAdsListTableHeader = {
        let tableHeader = FavoriteAdsListTableHeader(withAutoLayout: true)
        tableHeader.delegate = self
        tableHeader.searchBarDelegate = self
        return tableHeader
    }()

    private lazy var emptyView: FavoriteEmptyView = {
        let emptyView = FavoriteEmptyView(withAutoLayout: true)
        emptyView.isHidden = true
        return emptyView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteAdsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        addSubview(emptyView)

        tableView.fillInSuperview()
        tableHeaderView.searchBarPlaceholder = viewModel.searchBarPlaceholder
        emptyView.configure(withText: viewModel.emptyViewText, buttonTitle: nil)

        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        if !didSetTableHeader {
            setTableHeader()
            didSetTableHeader = true
        }
    }

    // MARK: - Reload

    public func reloadData() {
        showEmptyViewIfNeeded()

        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
    }

    // MARK: - Public methods

    public func setEditing(_ editing: Bool) {
        guard editing != tableView.isEditing else { return }

        let tableHeaderHeight = tableHeaderView.bounds.height
        let hasScrolledPastTableHeader = tableView.contentOffset.y >= tableHeaderHeight

        if !editing {
            setTableHeader()
            tableView.contentOffset.y += tableHeaderHeight
        } else {
            emptyView.removeConstraints(emptyViewConstraints)
            NSLayoutConstraint.deactivate(emptyViewConstraints)

            emptyViewConstraints = [emptyView.topAnchor.constraint(equalTo: topAnchor)]
            NSLayoutConstraint.activate(emptyViewConstraints)
        }

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.tableHeaderView.alpha = editing ? 0 : 1
            if !hasScrolledPastTableHeader {
                self.tableView.contentOffset.y = editing ? tableHeaderHeight : 0
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            if editing {
                self.tableView.contentOffset.y -= tableHeaderHeight
                self.tableView.tableHeaderView = nil
            }
        })

        tableView.setEditing(editing, animated: true)
    }

    public func selectAllRows(_ selected: Bool, animated: Bool) {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)

                if selected {
                    tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
                } else {
                    tableView.deselectRow(at: indexPath, animated: animated)
                }
            }
        }
    }

    public func reloadRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic) {
        tableView.reloadRows(at: [indexPath], with: animation)
    }

    public func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation = .automatic) {
        tableView.deleteRows(at: [indexPath], with: animation)
        showEmptyViewIfNeeded()
    }

    public func deleteSection(at index: Int, with animation: UITableView.RowAnimation = .automatic) {
        tableView.deleteSections(IndexSet(integer: index), with: animation)
        showEmptyViewIfNeeded()
    }

    // MARK: - Images

    public func cachedImage(forPath path: String) -> UIImage? {
        return imageCache.image(forKey: path)
    }

    // MARK: - Private

    private func setTableHeader() {
        tableView.tableHeaderView = tableHeaderView

        NSLayoutConstraint.deactivate(tableViewConstraints + emptyViewConstraints)
        tableHeaderView.removeConstraints(tableViewConstraints)
        emptyView.removeConstraints(emptyViewConstraints)

        tableViewConstraints = [
            tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            tableHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ]

        emptyViewConstraints = [
            emptyView.topAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -48)
        ]

        NSLayoutConstraint.activate(tableViewConstraints + emptyViewConstraints)

        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = tableView.tableHeaderView
        tableView.sendSubviewToBack(tableHeaderView)
    }

    private func showEmptyViewIfNeeded() {
        let shouldShowEmptyView = numberOfSections(in: tableView) == 0
        emptyView.isHidden = !shouldShowEmptyView
        tableHeaderView.isSortingViewHidden = shouldShowEmptyView
    }
}

// MARK: - UITableViewDelegate

extension FavoriteAdsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FavoriteAdTableViewCell {
            cell.loadImage()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableHeaderView.endEditing(true)
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        delegate?.favoriteAdsListView(self, didSelectItemAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.favoriteAdsListView(self, didSelectItemAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionTitle = dataSource?.favoriteAdsListView(self, titleForHeaderInSection: section) else { return nil }

        let headerView = tableView.dequeue(FavoriteAdsSectionHeaderView.self)
        headerView.configure(title: sectionTitle)
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard dataSource?.favoriteAdsListView(self, titleForHeaderInSection: section) != nil else { return .leastNonzeroMagnitude }
        return 32
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let comment = dataSource?.favoriteAdsListView(self, viewModelFor: indexPath).comment

        let commentAction = UIContextualAction(
            style: .normal,
            title: comment == nil ? viewModel.addCommentActionTitle : viewModel.editCommentActionTitle,
            handler: { [weak self] _, _, completionHandler in
                guard let self = self else { return }
                self.delegate?.favoriteAdsListView(self, didSelectCommentForItemAt: indexPath)
                completionHandler(true)
            })

        commentAction.backgroundColor = .licorice

        let deleteAction = UIContextualAction(
            style: .normal,
            title: viewModel.deleteAdActionTitle,
            handler: { [weak self] _, _, completionHandler in
                guard let self = self else { return }
                self.delegate?.favoriteAdsListView(self, didSelectDeleteItemAt: indexPath)
                completionHandler(true)
            })

        deleteAction.backgroundColor = .cherry

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, commentAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }
}

// MARK: - UITableViewDataSource

extension FavoriteAdsListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(inFavoriteAdsListView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inFavoriteAdsListView: self, forSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteAdTableViewCell.self, for: indexPath)
        cell.remoteImageViewDataSource = self
        cell.delegate = self

        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        cell.loadingColor = colors[indexPath.row % colors.count]

        if let viewModel = dataSource?.favoriteAdsListView(self, viewModelFor: indexPath) {
            cell.configure(with: viewModel)
        }
        return cell
    }
}

// MARK: - FavoriteAdTableViewCellDelegate

extension FavoriteAdsListView: FavoriteAdTableViewCellDelegate {
    public func favoriteAdTableViewCellDidSelectMoreButton(_ cell: FavoriteAdTableViewCell) {
        tableHeaderView.endEditing(true)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.favoriteAdsListView(self, didSelectMoreButtonForItemAt: indexPath)
    }
}

// MARK: - RemoteImageViewDataSource

extension FavoriteAdsListView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView,
                                cachedImageWithPath imagePath: String,
                                imageWidth: CGFloat) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(_ view: RemoteImageView,
                                loadImageWithPath imagePath: String,
                                imageWidth: CGFloat,
                                completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.favoriteAdsListView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }

            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView,
                                cancelLoadingImageWithPath imagePath: String,
                                imageWidth: CGFloat) {
        dataSource?.favoriteAdsListView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
    }
}

// MARK: - FavoriteAdsListTableHeaderDelegate

extension FavoriteAdsListView: FavoriteAdsListTableHeaderDelegate {
    func favoriteAdsListTableHeaderDidSelectSortingView(_ tableHeader: FavoriteAdsListTableHeader) {
        delegate?.favoriteAdsListViewDidSelectSortButton(self)
    }
}

// MARK: - UISearchBarDelegate

extension FavoriteAdsListView: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.favoriteAdsListView(self, didChangeSearchText: searchText)
    }
}

// MARK: - TableView

private class TableView: UITableView {
    /// Overridden so cells are resized after entering/exiting edit mode.
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        performBatchUpdates(nil)
    }
}
