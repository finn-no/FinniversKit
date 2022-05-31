//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FrontPageViewModel {
    var adRecommedationsGridViewHeaderTitle: String { get }
    var retryButtonTitle: String { get }
    var noRecommendationsText: String { get }
}

public protocol FrontPageViewDelegate: MarketsViewDelegate, AdRecommendationsGridViewDelegate {
    func frontPageViewDidSelectRetryButton(_ frontPageView: FrontPageView)
    func frontPageView(_ frontPageView: FrontPageView, didUnfavoriteRecentlyFavorited item: RecentlyFavoritedViewmodel)
}

public final class FrontPageView: UIView {
    
    public var model: FrontPageViewModel? {
        didSet {
            headerLabel.text = model?.adRecommedationsGridViewHeaderTitle
            adsRetryView.set(labelText: model?.noRecommendationsText, buttonText: model?.retryButtonTitle)
        }
    }

    public var isRefreshEnabled: Bool {
        get {
            return adRecommendationsGridView.isRefreshEnabled
        }
        set {
            adRecommendationsGridView.isRefreshEnabled = newValue
        }
    }
    
    var shelfViewModel: FrontPageShelfViewModel?
    
    public var frontPageShelfDelegate: FrontPageShelfDelegate? {
        didSet {
            frontPageShelfView?.shelfDelegate = frontPageShelfDelegate
        }
    }
    
    private enum CompactMarketsViewVisibilityStatus {
        case hidden
        case displaying(progress: CGFloat)
        case displayed
    }

    private weak var delegate: FrontPageViewDelegate?
    private var marketsViewDataSource: MarketsViewDataSource
    private var adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource
    private var didSetupView = false

    // MARK: - Subviews

    private lazy var marketsGridView: MarketsGridView = {
        let view = MarketsGridView(delegate: self, dataSource: marketsViewDataSource)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var compactMarketsView: CompactMarketsView = {
        let view = CompactMarketsView(delegate: self, dataSource: marketsViewDataSource)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var adRecommendationsGridView: AdRecommendationsGridView = {
        let view = AdRecommendationsGridView(delegate: self, dataSource: adRecommendationsGridViewDataSource)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let promoContainer = UIView(withAutoLayout: true)
    private let transactionFeedContainer = UIView(withAutoLayout: true)
    private let shelfContainer = UIView(withAutoLayout: true)
    private var isShowingShelf: Bool {
        guard let model = shelfViewModel else { return false }
        return model.heightForShelf > 0
    }
    
    private lazy var headerView = UIView(withAutoLayout: true)
    private var frontPageShelfView: FrontPageShelfView?
    
    private lazy var headerLabel: Label = {
        var headerLabel = Label(style: .title3Strong)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()

    private lazy var adsRetryView: LoadingRetryView = {
        let view = LoadingRetryView()
        view.delegate = self
        return view
    }()

    private lazy var marketsGridViewHeight = self.marketsGridView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var compactMarketsViewBottomConstraint = compactMarketsView.bottomAnchor.constraint(equalTo: topAnchor)

    private var keyValueObservation: NSKeyValueObservation?

    private var boundsForCurrentSubviewSetup = CGRect.zero
    private var remoteImageDataSource: RemoteImageViewDataSource

    // MARK: - Init

    public init(delegate: FrontPageViewDelegate, marketsViewDataSource: MarketsViewDataSource, adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource, remoteImageViewDataSource: RemoteImageViewDataSource) {
        self.delegate = delegate
        self.adRecommendationsGridViewDataSource = adRecommendationsGridViewDataSource
        self.marketsViewDataSource = marketsViewDataSource
        self.remoteImageDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        keyValueObservation?.invalidate()
    }

    // MARK: - Public

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        } else if !boundsForCurrentSubviewSetup.equalTo(bounds) {
            setupFrames()
        }
    }

    public func reloadData() {
        marketsGridView.reloadData()
        compactMarketsView.reloadData()
        setupFrames()
        reloadAds()
    }

    public func reloadMarkets() {
        marketsGridView.reloadData()
        compactMarketsView.reloadData()
        setupFrames()
        adRecommendationsGridView.reloadData()
    }

    public func reloadAds() {
        adsRetryView.state = .hidden
        adRecommendationsGridView.reloadData()
    }

    public func updateAd(at index: Int, isFavorite: Bool) {
        adRecommendationsGridView.updateItem(at: index, isFavorite: isFavorite)
    }

    public func showAdsRetryButton() {
        adRecommendationsGridView.endRefreshing()
        adsRetryView.state = .labelAndButton
    }

    public func scrollToTop() {
        adRecommendationsGridView.scrollToTop()
    }

    public func showPromotion(withViewModel viewModel: PromotionViewModel, andDelegate delegate: PromotionViewDelegate) {
        let promotionView = PromotionView(viewModel: viewModel)
        promotionView.delegate = delegate

        promoContainer.addSubview(promotionView)
        promotionView.fillInSuperview(
            insets: .init(
                top: .spacingL,
                leading: .spacingM,
                bottom: 0,
                trailing: -.spacingM
            )
        )

        setupFrames()
    }

    public func showTransactionFeed(
        withViewModel viewModel: FrontPageTransactionViewModel,
        andDelegate delegate: FrontPageTransactionViewDelegate
    ) {
        let transactionView = FrontPageTransactionView(withAutoLayout: true)
        transactionView.delegate = delegate
        transactionView.configure(with: viewModel, andImageDatasource: remoteImageDataSource)

        transactionFeedContainer.addSubview(transactionView)
        transactionView.fillInSuperview(insets: .init(top: .spacingL,
                                                      leading: .spacingM,
                                                      bottom: 0,
                                                      trailing: -.spacingM))
        setupFrames()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgQuaternary

        addSubview(adRecommendationsGridView)

        adRecommendationsGridView.collectionView.addSubview(adsRetryView)

        headerView.addSubview(marketsGridView)
        headerView.addSubview(promoContainer)
        headerView.addSubview(transactionFeedContainer)
        headerView.addSubview(shelfContainer)
        headerView.addSubview(headerLabel)

        addSubview(compactMarketsView)

        NSLayoutConstraint.activate([
            marketsGridView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: .spacingM),
            marketsGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketsGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            marketsGridViewHeight,
            
            promoContainer.topAnchor.constraint(equalTo: marketsGridView.bottomAnchor),
            promoContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            promoContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            transactionFeedContainer.topAnchor.constraint(equalTo: promoContainer.bottomAnchor),
            transactionFeedContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            transactionFeedContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            shelfContainer.topAnchor.constraint(equalTo: transactionFeedContainer.bottomAnchor),
            shelfContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            shelfContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: shelfContainer.bottomAnchor, constant: .spacingM),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .spacingM),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -.spacingM),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            compactMarketsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            compactMarketsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            compactMarketsViewBottomConstraint,
            compactMarketsView.heightAnchor.constraint(equalToConstant: compactMarketsView.calculateSize(constrainedTo: frame.width).height)
        ])

        adRecommendationsGridView.fillInSuperview()
        adRecommendationsGridView.headerView = headerView
        
        changeCompactMarketsViewVisibilityStatus(to: .hidden)

        setupFrames()
    }

    private func setupFrames() {
        let headerTopSpacing: CGFloat = .spacingM
        let headerBottomSpacing: CGFloat = .spacingS
        let labelHeight = headerLabel.intrinsicContentSize.height + .spacingM

        let promoContainerHeight = bounds.size.width == 0 ? 0 : promoContainer
            .systemLayoutSizeFitting(
                CGSize(width: bounds.size.width, height: 0),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
            .height
        let transactionFeedHeight = bounds.size.width == 0 ? 0 : transactionFeedContainer
            .systemLayoutSizeFitting(
                CGSize(width: bounds.size.width, height: 0),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
            .height

        let marketGridViewHeight = marketsGridView.calculateSize(constrainedTo: bounds.size.width).height + .spacingXS
        var height = headerTopSpacing + labelHeight + marketGridViewHeight + promoContainerHeight + transactionFeedHeight +  headerBottomSpacing

        let shelfContainerHeight = shelfViewModel?.heightForShelf ?? 0
        height += shelfContainerHeight + (shelfContainerHeight > 0 ? FrontPageShelfView.topPadding : 0)

        marketsGridViewHeight.constant = marketGridViewHeight
        headerView.frame.size.height = height
        adsRetryView.frame.origin = CGPoint(x: 0, y: headerView.frame.height + .spacingXXL)
        adsRetryView.frame.size = CGSize(width: bounds.width, height: 200)
        boundsForCurrentSubviewSetup = bounds
        adRecommendationsGridView.invalidateLayout()
    }

    // MARK: - Private methods
    
    public func configureFrontPageShelves(_ model: FrontPageShelfViewModel, firstVisibleSavedSearchIndex: Int?) {
        self.shelfViewModel = model

        if frontPageShelfView == nil {
            frontPageShelfView = FrontPageShelfView(withDatasource: self)
            frontPageShelfView?.translatesAutoresizingMaskIntoConstraints = false
            shelfContainer.addSubview(frontPageShelfView!)

            frontPageShelfView?.fillInSuperview(
                insets: .init(top: FrontPageShelfView.topPadding, leading: 0, bottom: 0, trailing: 0)
            )

            // Add a minimum height, since cells are never queried if the frame initially has height 0.
            frontPageShelfView?.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        }

        frontPageShelfView?.reloadShelf()

        if let firstVisibleSavedSearchIndex = firstVisibleSavedSearchIndex,
           model.savedSearchItems.indices.contains(firstVisibleSavedSearchIndex) {
            frontPageShelfView?.scrollToSavedSearch(atIndex: firstVisibleSavedSearchIndex)
        }

        setupFrames()
        
    }
    
    public func removeFrontShelf() {
        self.shelfViewModel = nil
        frontPageShelfView?.removeFromSuperview()
        frontPageShelfView = nil
        setupFrames()
    }
    
    private func changeCompactMarketsViewVisibilityStatus(to status: CompactMarketsViewVisibilityStatus) {
        switch status {
        case .displaying(progress: let progress):
            compactMarketsView.isHidden = false
            let height = compactMarketsView.calculateSize(constrainedTo: frame.width).height
            compactMarketsViewBottomConstraint.constant = height * progress
            layoutIfNeeded()
        case .displayed:
            compactMarketsView.isHidden = false
        case .hidden:
            compactMarketsView.isHidden = true
        }
    }
}

// MARK: - LoadingRetryViewDelegate

extension FrontPageView: LoadingRetryViewDelegate {
    public func loadingRetryViewDidSelectButton(_ view: LoadingRetryView) {
        adsRetryView.state = .loading
        delegate?.frontPageViewDidSelectRetryButton(self)
    }
}

// MARK: - AdRecommendationsGridViewDelegate

extension FrontPageView: AdRecommendationsGridViewDelegate {
    public func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {
        delegate?.adRecommendationsGridViewDidStartRefreshing(adRecommendationsGridView)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {
        delegate?.adRecommendationsGridView(adRecommendationsGridView, didSelectItemAtIndex: index)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        delegate?.adRecommendationsGridView(adRecommendationsGridView, willDisplayItemAtIndex: index)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {
        delegate?.adRecommendationsGridView(adRecommendationsGridView, didScrollInScrollView: scrollView)
        
        let verticalOffset = scrollView.contentOffset.y
        
        // Update Compact Markets View visibility
        let scrollingThreshold: CGFloat = 100
        let compactMarketsFullyDisplayedThreshold: CGFloat = 200
        // Will begin displaying compact markets at scrollingThreshold (100) and finish at compactMarketsFullyDisplayedThreshold (200)
        if verticalOffset >= scrollingThreshold {
            let currentDistance = verticalOffset - scrollingThreshold
            let endDistance = compactMarketsFullyDisplayedThreshold - scrollingThreshold
            let progress = max(0, min(1, currentDistance / endDistance))
            changeCompactMarketsViewVisibilityStatus(to: .displaying(progress: progress))
            if progress == 1 {
                changeCompactMarketsViewVisibilityStatus(to: .displayed)
            }
        } else {
            // When scrolling y offset is less than 100 hide the compact markets view
            changeCompactMarketsViewVisibilityStatus(to: .hidden)
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        delegate?.adRecommendationsGridView(adRecommendationsGridView, didSelectFavoriteButton: button, on: cell, at: index)
    }
}

// MARK: - MarketGridCollectionViewDelegate

extension FrontPageView: MarketsViewDelegate {
    public func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {
        delegate?.marketsView(marketsGridView, didSelectItemAtIndex: index)
    }
}

// MARK: - FrontPageShelfDatasource
extension FrontPageView: FrontPageShelfViewDataSource {
    public func frontPageShelfView(_ frontPageShelfView: FrontPageShelfView, titleForSectionAt index: Int) -> String {
        shelfViewModel?.titleForSection(at: index) ?? ""
    }
    
    public func frontPageShelfView(_ frontPageShelfView: FrontPageShelfView, titleForButtonForSectionAt index: Int) -> String {
        shelfViewModel?.titleForButton(at: index) ?? ""
    }
    
    public func frontPageShelfView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell? {
        if let item = item as? RecentlyFavoritedViewmodel {
            let cell = collectionView.dequeue(RecentlyFavoritedShelfCell.self, for: indexPath)
            cell.configure(withModel: item)
            cell.buttonAction = { [weak self] _, _ in
                self?.removeFavoritedItem(item, atIndexPath: indexPath)
            }
            cell.datasource = remoteImageDataSource
            cell.loadImage()
            
            return cell
        } else if let item = item as? SavedSearchShelfViewModel {
            let cell = collectionView.dequeue(SavedSearchShelfCell.self, for: indexPath)
            cell.configure(withModel: item)
            cell.imageDatasource = remoteImageDataSource
            cell.loadImage()
            return cell
        }
        return nil
    }
    
    public func frontPageShelfView(cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        [RecentlyFavoritedShelfCell.self, SavedSearchShelfCell.self]
    }
    
    public func datasource(forSection section: FrontPageShelfView.Section) -> [AnyHashable] {
        guard let model = shelfViewModel else { return [] }
        switch section {
        case .savedSearch: return model.savedSearchItems
        case .recentlyFavorited: return model.recentlyFavoritedItems
        }
    }
    
    public func removeFavoritedItem(_ item: AnyHashable, atIndexPath indexPath: IndexPath) {
        guard
            let favoriteModel = item as? RecentlyFavoritedViewmodel
        else { return }

        delegate?.frontPageView(self, didUnfavoriteRecentlyFavorited: favoriteModel)
    }
}
