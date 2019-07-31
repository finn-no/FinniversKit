//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFoldersListViewDelegate: AnyObject {
    func favoriteFoldersListView(_ view: FavoriteFoldersListView, didSelectItemAtIndex index: Int)
    func favoriteFoldersListViewDidSelectAddButton(_ view: FavoriteFoldersListView)
    func favoriteFoldersListViewDidSelectAddButton(_ view: FavoriteFoldersListView, withSearchText searchText: String)
    func favoriteFoldersListViewDidFocusSearchBar(_ view: FavoriteFoldersListView)
    func favoriteFoldersListView(_ view: FavoriteFoldersListView, didChangeSearchText searchText: String)
}

public protocol FavoriteFoldersListViewDataSource: AnyObject {
    func numberOfItems(inFavoriteFoldersListView view: FavoriteFoldersListView) -> Int
    func favoriteFoldersListView(_ view: FavoriteFoldersListView, viewModelAtIndex index: Int) -> FavoriteFolderViewModel
    func favoriteFoldersListView(
        _ view: FavoriteFoldersListView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    )
    func favoriteFoldersListView(
        _ view: FavoriteFoldersListView,
        cancelLoadingImageWithPath imagePath: String,
        imageWidth: CGFloat
    )
}

public class FavoriteFoldersListView: UIView {
    private enum Section: Int, CaseIterable {
        case addButton
        case folders
    }

    public static let estimatedRowHeight: CGFloat = 64.0

    // MARK: - Public properties

    public weak var delegate: FavoriteFoldersListViewDelegate?
    public weak var dataSource: FavoriteFoldersListViewDataSource?

    // MARK: - Private properties

    private let viewModel: FavoriteFoldersListViewModel
    private var isSearchActive = false
    private let imageCache = ImageMemoryCache()

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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(AddFavoriteFolderViewCell.self)
        tableView.register(FavoriteFolderSelectableViewCell.self)
        return tableView
    }()

    private lazy var footerView: FavoriteFoldersFooterView = {
        let view = FavoriteFoldersFooterView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var emptyView: FavoriteFoldersEmptyView = {
        let emptyView = FavoriteFoldersEmptyView(withAutoLayout: true)
        emptyView.delegate = self
        emptyView.isHidden = true
        return emptyView
    }()

    private lazy var searchBarTop = searchBar.topAnchor.constraint(equalTo: topAnchor)
    private lazy var footerViewTop = footerView.topAnchor.constraint(equalTo: bottomAnchor)

    private lazy var footerHeight: CGFloat = {
        return 56 + (viewModel.addBottomSafeAreaInset ? windowSafeAreaInsets.bottom : 0)
    }()

    // MARK: - Init

    public required init(viewModel: FavoriteFoldersListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reload

    public func reloadData() {
        showEmptyViewIfNeeded()

        if !tableView.isEditing {
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                guard let self = self else { return }
                self.footerViewTop.constant = self.isSearchActive ? -self.footerHeight : 0
                self.layoutIfNeeded()
            })
        }

        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
    }

    public func reloadRow(at index: Int, with animation: UITableView.RowAnimation = .none) {
        let section = Section.folders.rawValue

        guard index >= 0 && index < tableView(tableView, numberOfRowsInSection: section) else {
            assertionFailure("Trying to reload cell at invalid index path")
            return
        }

        let indexPath = IndexPath(row: index, section: section)
        tableView.reloadRows(at: [indexPath], with: animation)
    }

    public func setEditing(_ editing: Bool) {
        guard tableView.isEditing != editing else {
            return
        }

        if isSearchActive {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }

        let numberOfItems = self.tableView(tableView, numberOfRowsInSection: Section.addButton.rawValue)
        let performBatchUpdates = editing && numberOfItems == 1 || !editing && numberOfItems == 0

        tableView.setEditing(editing, animated: true)
        footerViewTop.constant = 0
        searchBarTop.constant = editing ? -searchBar.frame.height : 0

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layoutIfNeeded()
        }

        if #available(iOS 11.0, *), performBatchUpdates {
            tableView.performBatchUpdates({ [weak self] in
                let indexPaths = [IndexPath(row: 0, section: 0)]

                if editing {
                    self?.tableView.deleteRows(at: indexPaths, with: .top)
                } else {
                    self?.tableView.insertRows(at: indexPaths, with: .top)
                }
            }, completion: { [weak self] _ in
                self?.tableView.reloadData()
            })
        } else {
            tableView.reloadData()
        }
    }

    // MARK: - Setup

    private func setup() {
        emptyView.configure(withButtonTitle: viewModel.addFolderText, bodyTextPrefix: viewModel.emptyViewBodyPrefix)
        searchBar.configure(withPlaceholder: viewModel.searchBarPlaceholder)
        footerView.configure(withTitle: viewModel.addFolderText)

        addSubview(tableView)
        addSubview(searchBar)
        addSubview(footerView)
        addSubview(emptyView)

        NSLayoutConstraint.activate([
            searchBarTop,
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerViewTop,
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: footerHeight),

            emptyView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Private methods

    private func showEmptyViewIfNeeded() {
        let shouldShowEmptyView = (dataSource?.numberOfItems(inFavoriteFoldersListView: self) ?? 0) == 0
        emptyView.isHidden = !shouldShowEmptyView
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
            return isSearchActive || tableView.isEditing ? 0 : 1
        case .folders:
            return dataSource?.numberOfItems(inFavoriteFoldersListView: self) ?? 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .addButton:
            let cell = tableView.dequeue(AddFavoriteFolderViewCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.addFolderText)
            return cell
        case .folders:
            let cell = tableView.dequeue(FavoriteFolderSelectableViewCell.self, for: indexPath)

            // Show a pretty color while we load the image
            let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
            let color = colors[indexPath.row % 4]

            cell.loadingColor = color
            cell.dataSource = self

            if let viewModel = dataSource?.favoriteFoldersListView(self, viewModelAtIndex: indexPath.row) {
                cell.configure(with: viewModel, isEditing: tableView.isEditing, isEditable: indexPath.row != 0)
            }

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FavoriteFoldersListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .addButton:
            delegate?.favoriteFoldersListViewDidSelectAddButton(self)
        case .folders:
            delegate?.favoriteFoldersListView(self, didSelectItemAtIndex: indexPath.row)
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RemoteImageTableViewCell else {
            return
        }

        let isLastCell = indexPath.row == (self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1)

        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }

        cell.loadImage()
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing else { return true }
        guard let section = Section(rawValue: indexPath.section) else { return false }

        switch section {
        case .addButton:
            return false
        case .folders:
            return indexPath.row != 0
        }
    }
}

// MARK: - FavoriteFoldersFooterViewDelegate

extension FavoriteFoldersListView: FavoriteFoldersFooterViewDelegate {
    func favoriteFoldersFooterViewDidSelectButton(_ view: FavoriteFoldersFooterView) {
        delegate?.favoriteFoldersListViewDidSelectAddButton(self)
    }
}

// MARK: - RemoteImageViewDataSource

extension FavoriteFoldersListView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.favoriteFoldersListView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }

            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
        dataSource?.favoriteFoldersListView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
    }
}

// MARK: - UIScrollViewDelegate

extension FavoriteFoldersListView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.updateShadow(using: scrollView)

        guard !tableView.isEditing else {
            return
        }

        let offset = scrollView.contentOffset.y * 1.5
        let minOffset = FavoriteFoldersListView.estimatedRowHeight * 1.5
        let maxOffset = minOffset + footerHeight
        let hasShortContent = scrollView.contentSize.height <= (scrollView.frame.height + FavoriteFoldersListView.estimatedRowHeight)

        if hasShortContent && !isSearchActive {
            // Hide the footerView when there are few cells and a search isn't active.
            footerViewTop.constant = 0
        } else if offset > maxOffset || isSearchActive {
            // Stop sliding when the footer view appear in full height or when a search is active.
            footerViewTop.constant = -footerHeight
        } else if offset >= minOffset && offset <= maxOffset {
            // Slide up the footer view while the first cell with "Add folder" button is disappearing during scrolling.
            footerViewTop.constant = -offset + minOffset
        } else if offset <= footerHeight {
            // Hide the footer view when the first cell with "Add folder" button is visible.
            footerViewTop.constant = 0
        }
    }
}

// MARK: - UISearchBarDelegate

extension FavoriteFoldersListView: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.favoriteFoldersListViewDidFocusSearchBar(self)
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {
            isSearchActive = false
        }
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        isSearchActive = !searchText.isEmpty
        delegate?.favoriteFoldersListView(self, didChangeSearchText: searchText)
        emptyView.configure(withSearchTerm: searchText)
    }
}

// MARK: - FavoriteFoldersEmptyViewDelegate

extension FavoriteFoldersListView: FavoriteFoldersEmptyViewDelegate {
    func favoriteFoldersEmptyViewDidSelectAddFolderButton(_: FavoriteFoldersEmptyView) {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        delegate?.favoriteFoldersListViewDidSelectAddButton(self, withSearchText: searchText)
    }
}
