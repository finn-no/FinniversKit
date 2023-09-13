import SwiftUI
import UIKit

public protocol FrontPageViewModel {
    var marketsGridViewAccessibilityHeaderTitle: String { get }
    var adRecommedationsGridViewHeaderTitle: String { get set }
    var retryButtonTitle: String { get }
    var noRecommendationsText: String { get }
}

public protocol FrontPageViewDelegate: MarketsViewDelegate, AdRecommendationsGridViewDelegate {
    func frontPageViewDidSelectRetryButton(_ frontPageView: FrontPageView)
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

    var savedSearchesViewModel: FrontPageSavedSearchesViewModel?

    public var savedSearchesViewDelegate: FrontPageSavedSearchesViewDelegate? {
        didSet {
            frontPageSavedSearchView?.delegate = savedSearchesViewDelegate
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
        let view = MarketsGridView(accessibilityHeader: model?.marketsGridViewAccessibilityHeaderTitle ?? "", delegate: self, dataSource: marketsViewDataSource)
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
    private let savedSearchesContainer = UIView(withAutoLayout: true)
    private var isShowingSavedSearches: Bool {
        guard let model = savedSearchesViewModel else { return false }
        return model.height > 0
    }

    private lazy var headerView = UIView(withAutoLayout: true)
    private var frontPageSavedSearchView: FrontPageSavedSearchesView?
    
    private lazy var headerLabel: Label = {
        var headerLabel = Label(style: .title3Strong)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.accessibilityTraits.insert(.header)
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

    public func showBrazePromotion(withViewModel viewModel: BrazePromotionViewModel, andDelegate delegate: BrazePromotionViewDelegate) {
        let promotionView = BrazePromotionView(viewModel: viewModel, imageDatasource: remoteImageDataSource)
        promotionView.delegate = delegate

        headerView.addSubview(promoContainer)
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

    public func removeBrazePromotion() {
        promoContainer.subviews.forEach { $0.removeFromSuperview() }
        setupFrames()
    }

    public func showTransactionFeed(
        viewModels: [FrontPageTransactionViewModel],
        delegate: FrontPageTransactionViewModelDelegate,
        imageLoader: @escaping FrontPageTransactionViewModel.ImageLoader
    ) -> UIViewController {
        for viewModel in viewModels {
            viewModel.delegate = delegate
            viewModel.imageLoader = imageLoader
        }
        let listView = FrontPageTransactionListView(models: viewModels)
        let transactionListVC = UIHostingController(rootView: listView)
        transactionListVC.view.backgroundColor = .clear
        transactionFeedContainer.addSubview(transactionListVC.view)
        transactionListVC.view.fillInSuperview(insets: .init(
            top: .spacingL,
            leading: .spacingM,
            bottom: 0,
            trailing: -.spacingM
        ))
        setupFrames()
        return transactionListVC
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgQuaternary

        addSubview(adRecommendationsGridView)

        adRecommendationsGridView.collectionView.addSubview(adsRetryView)

        headerView.addSubview(marketsGridView)
        headerView.addSubview(promoContainer)
        headerView.addSubview(transactionFeedContainer)
        headerView.addSubview(savedSearchesContainer)
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
            
            savedSearchesContainer.topAnchor.constraint(equalTo: transactionFeedContainer.bottomAnchor),
            savedSearchesContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            savedSearchesContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: savedSearchesContainer.bottomAnchor, constant: .spacingM),
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

        let savedSearchesHeight = savedSearchesViewModel?.height ?? 0
        if savedSearchesHeight > 0 {
            height += savedSearchesHeight + FrontPageSavedSearchesView.topPadding
        }

        marketsGridViewHeight.constant = marketGridViewHeight
        headerView.frame.size.height = height
        adsRetryView.frame.origin = CGPoint(x: 0, y: headerView.frame.height + .spacingXXL)
        adsRetryView.frame.size = CGSize(width: bounds.width, height: 200)
        boundsForCurrentSubviewSetup = bounds
        adRecommendationsGridView.invalidateLayout()
    }

    // MARK: - Private methods

    public func configure(
        withSavedSearches savedSearchesViewModel: FrontPageSavedSearchesViewModel,
        firstVisibleSavedSearchIndex: Int?,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        self.savedSearchesViewModel = savedSearchesViewModel

        if frontPageSavedSearchView == nil {
            let frontPageSavedSearchView = FrontPageSavedSearchesView(
                title: savedSearchesViewModel.title,
                buttonTitle: savedSearchesViewModel.buttonTitle,
                remoteImageDataSource: remoteImageViewDataSource,
                withAutoLayout: true
            )
            self.frontPageSavedSearchView = frontPageSavedSearchView
            savedSearchesContainer.addSubview(frontPageSavedSearchView)

            frontPageSavedSearchView.fillInSuperview(
                insets: .init(top: FrontPageSavedSearchesView.topPadding, leading: 0, bottom: 0, trailing: 0)
            )
        }

        frontPageSavedSearchView?.configure(with: savedSearchesViewModel.searchViewModels)

        if let firstVisibleSavedSearchIndex = firstVisibleSavedSearchIndex,
           savedSearchesViewModel.searchViewModels.indices.contains(firstVisibleSavedSearchIndex) {
            frontPageSavedSearchView?.scrollToSavedSearch(atIndex: firstVisibleSavedSearchIndex)
        }

        setupFrames()
        
    }
    
    public func removeSavedSearches() {
        guard frontPageSavedSearchView != nil else { return }
        self.savedSearchesViewModel = nil
        frontPageSavedSearchView?.removeFromSuperview()
        frontPageSavedSearchView = nil
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
