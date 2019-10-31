//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdsListViewDelegate: AnyObject {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButton button: UIButton, at indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectDeleteItemAt indexPath: IndexPath, sender: UIView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectCommentForItemAt indexPath: IndexPath, sender: UIView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectSortingView sortingView: UIView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectHeaderShareButton button: UIButton)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectFooterShareButton button: UIButton)
    func favoriteAdsListViewDidFocusSearchBar(_ view: FavoriteAdsListView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didChangeSearchText searchText: String)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didUpdateTitleLabelVisibility isVisible: Bool)
}

public protocol FavoriteAdsListViewDataSource: AnyObject {
    func numberOfSections(inFavoriteAdsListView view: FavoriteAdsListView) -> Int
    func numberOfItems(inFavoriteAdsListView view: FavoriteAdsListView, forSection section: Int) -> Int
    func favoriteAdsListView(_ view: FavoriteAdsListView, titleForHeaderInSection section: Int) -> String?
    func favoriteAdsListView(_ view: FavoriteAdsListView, detailForHeaderInSection section: Int) -> String?
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

    public var isReadOnly: Bool {
        didSet {
            if didSetTableHeader {
                reloadData()
                setFooterVewHidden(isReadOnly || isFooterShareButtonHidden)
            }
        }
    }

    public var isSearchBarHidden: Bool {
        get { return tableHeaderView.isSearchBarHidden }
        set {
            tableHeaderView.isSearchBarHidden = newValue
            setTableHeader()
        }
    }

    public var title = "" {
        didSet {
            tableHeaderView.title = title
            if !tableView.isEditing {
                setTableHeader()
            }
        }
    }

    public var subtitle = "" {
        didSet { tableHeaderView.subtitle = subtitle }
    }

    public var searchBarText: String {
        get { return tableHeaderView.searchBarText }
        set { tableHeaderView.searchBarText = newValue }
    }

    public var sortingTitle = "" {
        didSet { tableHeaderView.sortingTitle = sortingTitle }
    }

    public var isShared = false {
        didSet {
            tableHeaderView.shareButtonTitle = isShared ? viewModel.headerShareButtonTitle : ""
        }
    }

    public var isFooterShareButtonHidden = true {
        didSet {
            setFooterVewHidden(isFooterShareButtonHidden)
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteAdsListViewModel
    private let imageCache = ImageMemoryCache()
    private var didSetTableHeader = false
    private var sendScrollUpdates: Bool = true
    private var tableViewConstraints = [NSLayoutConstraint]()
    private var contentSizeObserver: NSKeyValueObservation?
    private lazy var tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: topAnchor)
    private lazy var tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    private lazy var tableViewFooterBottomConstraint = tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)

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
        tableView.backgroundColor = .bgPrimary
        return tableView
    }()

    private lazy var tableHeaderView: FavoriteAdsListTableHeader = {
        let tableHeader = FavoriteAdsListTableHeader(withAutoLayout: true)
        tableHeader.delegate = self
        tableHeader.searchBarDelegate = self
        return tableHeader
    }()

    private lazy var emptySearchView: FavoriteSearchEmptyView = {
        let emptyView = FavoriteSearchEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()

    private lazy var emptyListView: FavoriteAdsListEmptyView = {
        let emptyView = FavoriteAdsListEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()

    private lazy var footerView: FooterButtonView = {
        let view = FooterButtonView(withAutoLayout: true)
        view.buttonTitle = viewModel.footerShareButtonTitle
        view.isHidden = true
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public init(viewModel: FavoriteAdsListViewModel, isReadOnly: Bool = false) {
        self.viewModel = viewModel
        self.isReadOnly = isReadOnly
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    deinit {
        contentSizeObserver?.invalidate()
        contentSizeObserver = nil
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        addSubview(footerView)

        tableView.addSubview(emptySearchView)
        tableView.addSubview(emptyListView)

        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewBottomConstraint,

            footerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        tableHeaderView.searchBarPlaceholder = viewModel.searchBarPlaceholder

        emptyListView.configure(withImage: viewModel.emptyListViewImage,
                                title: viewModel.emptyListViewTitle,
                                body: viewModel.emptyListViewBody)

        contentSizeObserver = tableView.observe(\UITableView.contentSize, options: [.new], changeHandler: { [weak self] tableView, _ in
            self?.footerView.updateShadow(using: tableView)
        })
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        if !didSetTableHeader {
            setTableHeader()
            didSetTableHeader = true
        } else {
            layoutEmptyViews()
        }
    }

    // MARK: - Reload

    public func reloadData() {
        showEmptySearchViewIfNeeded()

        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
    }

    // MARK: - Public methods

    public func setListIsEmpty(_ isEmpty: Bool) {
        emptyListView.isHidden = !isEmpty
        tableHeaderView.isSearchBarHidden = isEmpty
        tableHeaderView.isSortingViewHidden = isEmpty
        setTableHeader()
    }

    public func setEditing(_ editing: Bool) {
        guard editing != tableView.isEditing else { return }

        let tableHeaderHeight = tableHeaderView.bounds.height
        let hasScrolledPastTableHeader = tableView.contentOffset.y >= tableHeaderHeight
        let isContentTallEnoughForAnimatingOffset = tableView.contentSize.height > bounds.height + tableHeaderHeight

        setFooterVewHidden(editing || isFooterShareButtonHidden)

        if !editing {
            sendScrollUpdates = true
            setTableHeader()
            tableView.contentOffset.y += tableHeaderHeight
        }

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.tableHeaderView.alpha = editing ? 0 : 1
            if editing && !isContentTallEnoughForAnimatingOffset {
                self.tableViewTopConstraint.constant = -tableHeaderHeight
                self.layoutIfNeeded()
            } else if !hasScrolledPastTableHeader {
                self.tableView.contentOffset.y = editing ? tableHeaderHeight : 0
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            if editing {
                self.sendScrollUpdates = false
                self.tableView.contentOffset.y -= tableHeaderHeight
                self.tableView.tableHeaderView = nil

                if !isContentTallEnoughForAnimatingOffset {
                    self.tableViewTopConstraint.constant = 0
                    self.layoutIfNeeded()
                    self.delegate?.favoriteAdsListView(self, didUpdateTitleLabelVisibility: false)
                }
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
        showEmptySearchViewIfNeeded()
    }

    public func deleteSection(at index: Int, with animation: UITableView.RowAnimation = .automatic) {
        tableView.deleteSections(IndexSet(integer: index), with: animation)
        showEmptySearchViewIfNeeded()
    }

    // MARK: - Images

    public func cachedImage(forPath path: String) -> UIImage? {
        return imageCache.image(forKey: path)
    }

    // MARK: - Private

    private func setTableHeader() {
        tableView.tableHeaderView = tableHeaderView

        NSLayoutConstraint.deactivate(tableViewConstraints)
        tableHeaderView.removeConstraints(tableViewConstraints)

        tableViewConstraints = [
            tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            tableHeaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ]

        NSLayoutConstraint.activate(tableViewConstraints)

        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = tableView.tableHeaderView
        tableView.sendSubviewToBack(tableHeaderView)

        layoutEmptyViews()
    }

    private func showEmptySearchViewIfNeeded() {
        let shouldShowEmptySearchView = numberOfSections(in: tableView) == 0
        emptySearchView.isHidden = !shouldShowEmptySearchView
        tableHeaderView.isSortingViewHidden = shouldShowEmptySearchView
        setFooterVewHidden(shouldShowEmptySearchView || isFooterShareButtonHidden)
        setTableHeader()
    }

    private func layoutEmptyViews() {
        emptySearchView.frame = tableView.bounds
        emptySearchView.frame.origin.y = tableView.tableHeaderView?.frame.height ?? 0
        emptySearchView.frame.size.height -= emptySearchView.frame.origin.y

        emptyListView.frame = emptySearchView.frame
    }

    private func setFooterVewHidden(_ hidden: Bool) {
        footerView.isHidden = hidden
        tableViewBottomConstraint.isActive = hidden
        tableViewFooterBottomConstraint.isActive = !hidden
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
        let sectionDetail = dataSource?.favoriteAdsListView(self, detailForHeaderInSection: section)

        let headerView = tableView.dequeue(FavoriteAdsSectionHeaderView.self)
        headerView.configure(title: sectionTitle, detail: sectionDetail)
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard dataSource?.favoriteAdsListView(self, titleForHeaderInSection: section) != nil else { return .leastNonzeroMagnitude }
        return 32
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isReadOnly
    }

    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard !isReadOnly else {
            return nil
        }

        let comment = dataSource?.favoriteAdsListView(self, viewModelFor: indexPath).comment

        let commentAction = UIContextualAction(
            style: .normal,
            title: comment == nil ? viewModel.addCommentActionTitle : viewModel.editCommentActionTitle,
            handler: { [weak self] _, sender, completionHandler in
                guard let self = self else { return }
                self.delegate?.favoriteAdsListView(self, didSelectCommentForItemAt: indexPath, sender: sender)
                completionHandler(true)
            })

        commentAction.backgroundColor = .licorice

        let deleteAction = UIContextualAction(
            style: .normal,
            title: viewModel.deleteAdActionTitle,
            handler: { [weak self] _, sender, completionHandler in
                guard let self = self else { return }
                self.delegate?.favoriteAdsListView(self, didSelectDeleteItemAt: indexPath, sender: sender)
                completionHandler(true)
            })

        deleteAction.backgroundColor = .btnCritical

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, commentAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        footerView.updateShadow(using: scrollView)

        if sendScrollUpdates {
            let isTitleViewVisible = scrollView.bounds.intersects(tableHeaderView.titleLabelFrame)
            delegate?.favoriteAdsListView(self, didUpdateTitleLabelVisibility: isTitleViewVisible)
        }
    }

    private func titleLabelVisiblePercent(scrollView: UIScrollView) -> CGFloat {
        let scrollOffset = scrollView.contentOffset.y
        let labelStart = tableHeaderView.titleLabelFrame.minY
        let labelEnd = tableHeaderView.titleLabelFrame.maxY

        let percentVisible = 1 - (scrollOffset-labelStart)/(labelEnd-labelStart)
        return min(1, max(percentVisible, 0))
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
        cell.isMoreButtonHidden = isReadOnly

        if let viewModel = dataSource?.favoriteAdsListView(self, viewModelFor: indexPath) {
            cell.configure(with: viewModel)
        }

        return cell
    }
}

// MARK: - FavoriteAdTableViewCellDelegate

extension FavoriteAdsListView: FavoriteAdTableViewCellDelegate {
    public func favoriteAdTableViewCell(_ cell: FavoriteAdTableViewCell, didSelectMoreButton button: UIButton) {
        tableHeaderView.endEditing(true)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.favoriteAdsListView(self, didSelectMoreButton: button, at: indexPath)
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
    func favoriteAdsListTableHeader(_ tableHeader: FavoriteAdsListTableHeader, didSelectSortingView view: UIView) {
        delegate?.favoriteAdsListView(self, didSelectSortingView: view)
    }

    func favoriteAdsListTableHeader(_ tableHeader: FavoriteAdsListTableHeader, didSelectShareButton button: UIButton) {
        delegate?.favoriteAdsListView(self, didSelectHeaderShareButton: button)
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

        let emptyViewText = "\(viewModel.emptySearchViewBodyPrefix) \"\(searchText)\""
        emptySearchView.configure(withText: emptyViewText, buttonTitle: nil)
    }
}

// MARK: - FooterButtonViewDelegate

extension FavoriteAdsListView: FooterButtonViewDelegate {
    public func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton) {
        delegate?.favoriteAdsListView(self, didSelectFooterShareButton: button)
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
