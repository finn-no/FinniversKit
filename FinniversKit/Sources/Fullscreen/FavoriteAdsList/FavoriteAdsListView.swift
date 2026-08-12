//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public protocol FavoriteAdsListViewDelegate: AnyObject {
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectItemAt indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectMoreButton button: UIButton, at indexPath: IndexPath)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectDeleteItemAt indexPath: IndexPath, sender: UIView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectCommentForItemAt indexPath: IndexPath, sender: UIView)
    func favoriteAdsListView(_ view: FavoriteAdsListView, didSelectShareItemAt indexPath: IndexPath, sender: UIView)
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
                             completion: @escaping @Sendable ((UIImage?) -> Void)
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
            reloadData(scrollToTop: true)
        }
    }

    public var isSearchBarHidden: Bool {
        get { return tableHeaderView.isSearchBarHidden }
        set {
            tableHeaderView.isSearchBarHidden = newValue
            setTableHeader()
        }
    }

    /// When true, hides the built-in search bar and prevents `setListIsEmpty(_:)` from
    /// toggling it back on. Set this when the host provides its own search UI
    /// (for example a navigation-bar search button that reveals a docked search bar).
    /// Defaults to false to preserve existing behavior.
    public var isSearchBarPermanentlyHidden: Bool = false {
        didSet {
            if isSearchBarPermanentlyHidden {
                isSearchBarHidden = true
            }
        }
    }

    /// When true, hides the built-in sorting view (the "Sort by" dropdown) and prevents
    /// `setListIsEmpty(_:)` from toggling it back on. Set this when the host exposes sort
    /// through a different affordance (for example a navigation-bar overflow menu).
    /// Defaults to false to preserve existing behavior.
    public var isSortingViewPermanentlyHidden: Bool = false {
        didSet {
            if isSortingViewPermanentlyHidden {
                tableHeaderView.isSortingViewHidden = true
                setTableHeader()
            }
        }
    }

    /// When true, the per-row ⋮ affordance is hidden on every editable row. Use
    /// this when a consumer has migrated the per-item actions (comment / share /
    /// delete) to trailing swipes and doesn't want the redundant button.
    /// Defaults to false to preserve existing behavior.
    public var isMoreButtonPermanentlyHidden: Bool = false {
        didSet {
            guard isMoreButtonPermanentlyHidden != oldValue else { return }
            tableView.reloadData()
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

    /// Optional accessory view rendered at the bottom of the built-in table header, below
    /// the title/subtitle/messages/sorting content. Consumers use this to layer secondary
    /// controls (e.g. a status segmented control) that should scroll together with the
    /// header content. Set to `nil` to remove. Assigning triggers a header relayout.
    public var tableHeaderAccessoryView: UIView? {
        didSet {
            tableHeaderView.setBottomAccessoryView(tableHeaderAccessoryView)
            reloadTableHeader()
        }
    }

    /// Optional view used as the section header for section 0. Because the underlying
    /// table view uses `.plain` style, this view pins to the top of the visible area
    /// when the user scrolls past the built-in title header — matching designs that
    /// need a control (e.g. a status segmented control) to stay reachable while the
    /// list scrolls. When `nil`, section 0 uses the default title-based header.
    public var pinnedSectionZeroHeaderView: UIView? {
        didSet {
            // Reload only the header of section 0 so the new view is picked up
            // without disrupting cell state.
            guard tableView.numberOfSections > 0 else { return }
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteAdsListViewModel
    private let imageCache = ImageMemoryCache()
    private var sendScrollUpdates: Bool = true
    private lazy var scrollShadowView = BottomShadowView(withAutoLayout: true)
    private lazy var tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: topAnchor)
    private lazy var scrollShadowViewTopConstraint = scrollShadowView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
    private lazy var scrollShadowViewHeightConstraint = scrollShadowView.heightAnchor.constraint(equalToConstant: 0)

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
        tableView.backgroundColor = .background
        tableView.sectionHeaderTopPadding = 0
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

    // MARK: - Init

    public init(viewModel: FavoriteAdsListViewModel, isReadOnly: Bool = false) {
        self.viewModel = viewModel
        self.isReadOnly = isReadOnly
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        addSubview(scrollShadowView)

        tableView.addSubview(emptySearchView)
        tableView.addSubview(emptyListView)

        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            scrollShadowViewTopConstraint,
            scrollShadowViewHeightConstraint,
            scrollShadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollShadowView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        tableHeaderView.searchBarPlaceholder = viewModel.searchBarPlaceholder

        emptyListView.configure(withImage: viewModel.emptyListViewImage,
                                title: viewModel.emptyListViewTitle,
                                body: viewModel.emptyListViewBody)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        setTableHeader()
        layoutEmptyViews()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Reset header if content size category changes.
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setTableHeader()
        }
    }

    // MARK: - Reload

    public func reloadData(scrollToTop: Bool) {
        showEmptySearchViewIfNeeded()

        if scrollToTop {
            tableView.setContentOffset(.zero, animated: true)
        }
        tableView.reloadData()
    }

    // MARK: - Public methods

    public func configure(infoMessages: [FavoriteAdsListMessageKind]) {
        tableHeaderView.configure(infoMessages: infoMessages)
        setTableHeader()
    }

    /// Re-measures and re-installs the built-in table header. Call after changing
    /// `tableHeaderAccessoryView` at runtime, so the tableView picks up the new size.
    public func reloadTableHeader() {
        setTableHeader()
    }

    public func configure(scrollShadowHeight: CGFloat) {
        scrollShadowViewTopConstraint.constant = -scrollShadowHeight
        scrollShadowViewHeightConstraint.constant = scrollShadowHeight
        layoutIfNeeded()
    }

    /// Updates the "no results" empty view text using the view model's prefix.
    /// Call this from a consumer when using a custom (external) search input, since
    /// the built-in search bar is the only thing that updates this text automatically.
    public func updateSearchEmptyText(for searchText: String) {
        let emptyViewText = "\(viewModel.emptySearchViewBodyPrefix) \"\(searchText)\""
        emptySearchView.configure(withText: emptyViewText, buttonTitle: nil)
    }

    public func setListIsEmpty(_ isEmpty: Bool) {
        emptyListView.isHidden = !isEmpty
        if !isSearchBarPermanentlyHidden {
            tableHeaderView.isSearchBarHidden = isEmpty
        }
        if !isSortingViewPermanentlyHidden {
            tableHeaderView.isSortingViewHidden = isEmpty
        }
        setTableHeader()
    }

    public func setEditing(_ editing: Bool) {
        guard editing != tableView.isEditing else { return }

        let tableHeaderHeight = tableHeaderView.bounds.height
        let hasScrolledPastTableHeader = tableView.contentOffset.y >= tableHeaderHeight
        let isContentTallEnoughForAnimatingOffset = tableView.contentSize.height > bounds.height + tableHeaderHeight

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
        layoutTableHeaderView()
        tableView.sendSubviewToBack(tableHeaderView)

        layoutEmptyViews()
    }

    private func showEmptySearchViewIfNeeded() {
        // The search-specific empty view should only appear when the user is
        // actually searching. Without this gate it stacks on top of the
        // "no favorites yet" empty view whenever both the section count is zero
        // and the folder is empty, producing two overlapping empty states.
        let hasSearchText = !searchBarText.isEmpty
        let shouldShowEmptySearchView = numberOfSections(in: tableView) == 0 && hasSearchText
        emptySearchView.isHidden = !shouldShowEmptySearchView
        if !isSortingViewPermanentlyHidden {
            tableHeaderView.isSortingViewHidden = shouldShowEmptySearchView
        }
        setTableHeader()
    }

    private func layoutEmptyViews() {
        // Both empty views cover the full table area so their hosted Warp StateView
        // centers vertically in the whole visible region. The tableHeaderView (title
        // + subtitle) remains visible because both empty views use a clear
        // background.
        emptySearchView.frame = tableView.bounds
        emptyListView.frame = tableView.bounds
    }

    /// Calculates the correct frame for the `tableHeaderView` on each call to `layoutSubviews`.
    /// Slightly modified of https://stackoverflow.com/a/54237526
    private func layoutTableHeaderView() {
        guard let headerView = tableView.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = bounds.width
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerWidth)

        headerView.addConstraint(temporaryWidthConstraint)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let headerSize = headerView.systemLayoutSizeFitting(
            CGSize(width: headerWidth, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )

        let height = headerSize.height
        var frame = headerView.frame

        frame.size.height = height
        headerView.frame = frame

        tableView.tableHeaderView = headerView

        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

// MARK: - UITableViewDelegate

extension FavoriteAdsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1)

        if isLastCell {
            cell.separatorInset = .leadingInset(.greatestFiniteMagnitude)
        }

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
        if section == 0, let pinnedView = pinnedSectionZeroHeaderView {
            return PinnedHeaderContainerView(contentView: pinnedView)
        }

        guard let sectionTitle = dataSource?.favoriteAdsListView(self, titleForHeaderInSection: section) else { return nil }
        let sectionDetail = dataSource?.favoriteAdsListView(self, detailForHeaderInSection: section)

        let headerView = tableView.dequeue(FavoriteAdsSectionHeaderView.self)
        headerView.configure(title: sectionTitle, detail: sectionDetail)
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0, pinnedSectionZeroHeaderView != nil {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
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

        // Warp amber matches Figma's "Add note" / "Edit note" affordance and
        // groups the action visually with note-editing (soft warning tone).
        commentAction.backgroundColor = Warp.UIToken.backgroundWarning
        commentAction.image = UIImage(systemName: "pencil")

        let shareAction = UIContextualAction(
            style: .normal,
            title: viewModel.shareAdActionTitle,
            handler: { [weak self] _, sender, completionHandler in
                guard let self = self else { return }
                self.delegate?.favoriteAdsListView(self, didSelectShareItemAt: indexPath, sender: sender)
                completionHandler(true)
            })

        // Warp `backgroundInfo` matches the softer Figma share swatch — the
        // brighter `backgroundPrimary` (primary CTA blue) reads too strong here.
        shareAction.backgroundColor = Warp.UIToken.backgroundInfo
        shareAction.image = UIImage(systemName: "square.and.arrow.up")

        let deleteAction = UIContextualAction(
            style: .normal,
            title: viewModel.deleteAdActionTitle,
            handler: { [weak self] _, sender, completionHandler in
                guard let self = self else { return }
                self.delegate?.favoriteAdsListView(self, didSelectDeleteItemAt: indexPath, sender: sender)
                completionHandler(true)
            })

        deleteAction.backgroundColor = .backgroundNegative
        deleteAction.image = UIImage(systemName: "trash")

        // Rightmost (index 0) is comment because it is the most-used per-ad
        // action; delete moves to the far left where the destructive action
        // requires an explicit reach. Matches the Figma "Add note | Share | Delete"
        // visual order (right-to-left in swipe reveal terms).
        let configuration = UISwipeActionsConfiguration(actions: [commentAction, shareAction, deleteAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollShadowView.updateShadow(using: scrollView)

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

        cell.isMoreButtonHidden = isReadOnly || isMoreButtonPermanentlyHidden

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
                                completion: @escaping @Sendable ((UIImage?) -> Void)) {
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

// MARK: - PinnedHeaderContainerView

/// Wraps a caller-supplied view so it can be returned from `viewForHeaderInSection`.
/// Section headers must be `UITableViewHeaderFooterView` (or a UIView) that owns the
/// content; embedding the caller's view lets us reuse it across section reloads
/// without recreating it. Height is driven by the caller's Auto Layout constraints.
private final class PinnedHeaderContainerView: UIView {
    init(contentView: UIView) {
        super.init(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // Remove from any prior superview so section reloads don't leave it detached.
        contentView.removeFromSuperview()
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
