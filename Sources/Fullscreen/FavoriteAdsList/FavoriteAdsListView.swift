//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdsListViewDelegate: AnyObject {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButtonForItemAt indexPath: IndexPath)
    func favoriteAdsListViewDidSelectSortButton(_ view: FavoriteAdsListView)
    func favoriteAdsListViewDidFocusSearchBar(_ view: FavoriteAdsListView)
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

    public var title: String = "" {
        didSet { tableHeaderView.title = title }
    }

    public var subtitle: String = "" {
        didSet { tableHeaderView.subtitle = subtitle }
    }

    public var searchBarPlaceholder: String = "" {
        didSet { tableHeaderView.searchBarPlaceholder = searchBarPlaceholder }
    }

    public var searchBarText: String {
        get { return tableHeaderView.searchBarText }
        set { tableHeaderView.searchBarText = newValue }
    }

    public var sortingTitle: String = "" {
        didSet { tableHeaderView.sortingTitle = sortingTitle }
    }

    // MARK: - Private properties

    private let imageCache = ImageMemoryCache()
    private var didSetTableHeader = false

    private lazy var tableView: UITableView = {
        let tableView = TableView(withAutoLayout: true)
        tableView.register(FavoriteAdTableViewCell.self)
        tableView.register(FavoriteAdsSectionHeaderView.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .leadingInset(frame.width)
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()

    private lazy var tableHeaderView: FavoriteAdsListTableHeader = {
        let tableHeader = FavoriteAdsListTableHeader(withAutoLayout: true)
        tableHeader.delegate = self
        tableHeader.searchBarDelegate = self
        return tableHeader
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        if !didSetTableHeader {
            tableView.tableHeaderView = tableHeaderView

            NSLayoutConstraint.activate([
                tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
                tableHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
            ])

            tableView.tableHeaderView?.layoutIfNeeded()
            tableView.tableHeaderView = tableView.tableHeaderView

            didSetTableHeader = true
        }
    }

    // MARK: - Reload

    public func reloadData() {
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
    }

    // MARK: - Public methods

    public func setEditing(_ editing: Bool) {
        guard editing != tableView.isEditing else { return }
        tableView.setEditing(editing, animated: true)
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
            delegate?.favoriteAdsListView(self, didSelectItemAt: indexPath)
        }
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
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.favoriteAdsListViewDidFocusSearchBar(self)
    }

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
