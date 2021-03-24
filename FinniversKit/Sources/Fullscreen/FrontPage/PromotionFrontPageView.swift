//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol PromotionFrontPageViewDelegate: AnyObject {
    func promotionFrontPageViewDidSelectRetryButton(_ frontPageView: PromotionFrontPageView)
}

public final class PromotionFrontPageView: UIView {

    // MARK: - Public properties

    public var model: FrontPageViewModel? {
        didSet {
            headerLabel.text = model?.adRecommedationsGridViewHeaderTitle
            adsRetryView.set(labelText: model?.noRecommendationsText, buttonText: model?.retryButtonTitle)
        }
    }

    public var isRefreshEnabled: Bool {
        get { adRecommendationsGridView.isRefreshEnabled }
        set { adRecommendationsGridView.isRefreshEnabled = newValue }
    }

    // MARK: - Private properties

    private weak var delegate: PromotionFrontPageViewDelegate?
    private weak var adRecommendationsGridViewDelegate: AdRecommendationsGridViewDelegate?
    private var didSetupView = false
    private var promoViewHeight: CGFloat = 150 // Should be gettable from the promo view itself.

    // MARK: - Subviews

    private let marketsView: CompactMarketsView
    private lazy var headerView = UIView()
    private let adRecommendationsGridView: AdRecommendationsGridView

    private lazy var promoView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .red
        return view
    }()

    private lazy var headerLabel: Label = {
        var headerLabel = Label(style: .title3)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()

    private lazy var adsRetryView: LoadingRetryView = {
        let view = LoadingRetryView()
        view.delegate = self
        return view
    }()

    private lazy var promoViewTopConstraint = promoView.topAnchor.constraint(equalTo: topAnchor)
    private lazy var marketsViewHeightConstraint = marketsView.heightAnchor.constraint(equalToConstant: 0)

    private var keyValueObservation: NSKeyValueObservation?

    private var boundsForCurrentSubviewSetup = CGRect.zero

    // MARK: - Init

    public convenience init(delegate: PromotionFrontPageViewDelegate & MarketsViewDelegate & MarketsViewDataSource & AdRecommendationsGridViewDelegate, adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource) {
        self.init(delegate: delegate, marketsGridViewDelegate: delegate, marketsGridViewDataSource: delegate, adRecommendationsGridViewDelegate: delegate, adRecommendationsGridViewDataSource: adRecommendationsGridViewDataSource)
    }

    public init(delegate: PromotionFrontPageViewDelegate, marketsGridViewDelegate: MarketsViewDelegate, marketsGridViewDataSource: MarketsViewDataSource, adRecommendationsGridViewDelegate: AdRecommendationsGridViewDelegate, adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource) {
        marketsView = CompactMarketsView(delegate: marketsGridViewDelegate, dataSource: marketsGridViewDataSource)
        marketsView.translatesAutoresizingMaskIntoConstraints = false

        adRecommendationsGridView = AdRecommendationsGridView(withAutoLayout: true)
        self.adRecommendationsGridViewDelegate = adRecommendationsGridViewDelegate

        super.init(frame: .zero)
        self.delegate = delegate
        adRecommendationsGridView.dataSource = adRecommendationsGridViewDataSource
        adRecommendationsGridView.delegate = self
        adRecommendationsGridView.setup()
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
        marketsView.reloadData()
        setupFrames()
        reloadAds()
    }

    public func reloadMarkets() {
        marketsView.reloadData()
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

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(promoView)
        addSubview(marketsView)
        addSubview(adRecommendationsGridView)

        adRecommendationsGridView.collectionView.addSubview(adsRetryView)

        NSLayoutConstraint.activate([
            promoViewTopConstraint,
            promoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            promoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            promoView.heightAnchor.constraint(equalToConstant: promoViewHeight),

            marketsView.topAnchor.constraint(equalTo: promoView.bottomAnchor),
            marketsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            marketsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            marketsViewHeightConstraint,

            adRecommendationsGridView.topAnchor.constraint(equalTo: marketsView.bottomAnchor),
            adRecommendationsGridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adRecommendationsGridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adRecommendationsGridView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupFrames()
    }

    private func setupFrames() {
        let marketGridViewHeight = marketsView.calculateSize(constrainedTo: bounds.size.width).height + .spacingXS

        marketsViewHeightConstraint.constant = marketGridViewHeight
        adsRetryView.frame.origin = .zero
        adsRetryView.frame.size = CGSize(width: bounds.width, height: 200)
        boundsForCurrentSubviewSetup = bounds
        adRecommendationsGridView.invalidateLayout()
    }
}

// MARK: - LoadingRetryViewDelegate

extension PromotionFrontPageView: LoadingRetryViewDelegate {
    func loadingRetryViewDidSelectButton(_ view: LoadingRetryView) {
        adsRetryView.state = .loading
        delegate?.promotionFrontPageViewDidSelectRetryButton(self)
    }
}

// MARK: - AdRecommendationsGridViewDelegate proxy

extension PromotionFrontPageView: AdRecommendationsGridViewDelegate {
    public func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {
        adRecommendationsGridViewDelegate?.adRecommendationsGridViewDidStartRefreshing(adRecommendationsGridView)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {
        adRecommendationsGridViewDelegate?.adRecommendationsGridView(adRecommendationsGridView, didSelectItemAtIndex: index)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        adRecommendationsGridViewDelegate?.adRecommendationsGridView(adRecommendationsGridView, willDisplayItemAtIndex: index)
    }

    public func adRecommendationsGridView(
        _ adRecommendationsGridView: AdRecommendationsGridView,
        didScrollInScrollView scrollView: UIScrollView
    ) {
        let offset = scrollView.contentOffset.y
        let maxOffset = promoViewHeight

        if offset <= 0 {
            promoViewTopConstraint.constant = 0
        } else if offset >= maxOffset {
            promoViewTopConstraint.constant = -maxOffset
        } else {
            promoViewTopConstraint.constant = -offset
        }

        adRecommendationsGridViewDelegate?.adRecommendationsGridView(adRecommendationsGridView, didScrollInScrollView: scrollView)
    }

    public func adRecommendationsGridView(
        _ adRecommendationsGridView: AdRecommendationsGridView,
        didSelectFavoriteButton button: UIButton,
        on cell: AdRecommendationCell,
        at index: Int
    ) {
        adRecommendationsGridViewDelegate?.adRecommendationsGridView(adRecommendationsGridView, didSelectFavoriteButton: button, on: cell, at: index)
    }
}
