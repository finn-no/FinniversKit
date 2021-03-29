//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol PromotionFrontPageViewDelegate: AnyObject {
    func promotionFrontPageViewDidSelectRetryButton(_ frontPageView: PromotionFrontPageView)
    func promotionFrontPageView(_ frontPageView: PromotionFrontPageView, promoViewHiddenPercentage percentage: CGFloat)
}

public final class PromotionFrontPageView: UIView, BasicFrontPageView {

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

    public var marketsViewCalloutYAxisAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? {
        marketsView.bottomAnchor
    }

    // MARK: - Private properties

    private weak var delegate: PromotionFrontPageViewDelegate?
    private weak var adRecommendationsGridViewDelegate: AdRecommendationsGridViewDelegate?
    private var didSetupView = false

    // MARK: - Subviews

    private let marketsView: CompactMarketsView
    private lazy var headerView = UIView()
    private let adRecommendationsGridView: AdRecommendationsGridView

    private lazy var promoSlidesView: PromoSlidesView = {
        let view = PromoSlidesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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

    private lazy var promoViewTopConstraint = promoSlidesView.topAnchor.constraint(equalTo: adRecommendationsGridView.topAnchor)
    private lazy var promoViewHeightConstraint = promoSlidesView.heightAnchor.constraint(equalToConstant: 156)
    private lazy var marketsViewHeightConstraint = marketsView.heightAnchor.constraint(equalToConstant: 0)
    private var boundsForCurrentSubviewSetup = CGRect.zero

    // MARK: - Init

    public convenience init(delegate: PromotionFrontPageViewDelegate & MarketsViewDelegate & MarketsViewDataSource & AdRecommendationsGridViewDelegate, adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource) {
        self.init(delegate: delegate, marketsViewDelegate: delegate, marketsViewDataSource: delegate, adRecommendationsGridViewDelegate: delegate, adRecommendationsGridViewDataSource: adRecommendationsGridViewDataSource)
    }

    public init(
        delegate: PromotionFrontPageViewDelegate,
        marketsViewDelegate: MarketsViewDelegate,
        marketsViewDataSource: MarketsViewDataSource,
        adRecommendationsGridViewDelegate: AdRecommendationsGridViewDelegate,
        adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource
    ) {
        marketsView = CompactMarketsView(delegate: marketsViewDelegate, dataSource: marketsViewDataSource)
        marketsView.translatesAutoresizingMaskIntoConstraints = false
        marketsView.backgroundColor = .bgPrimary

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

    public func configure(withPromoSlides promoSlides: [UIView]) {
        promoSlidesView.configure(withSlides: promoSlides)
        if #available(iOS 14.0, *) {
            promoViewHeightConstraint.constant = promoSlides.count == 1 ? 148 : 156
        } else {
            promoViewHeightConstraint.constant = 170
        }
        setupFrames()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        headerView.addSubview(headerLabel)

        addSubview(adRecommendationsGridView)
        adRecommendationsGridView.fillInSuperview()
        adRecommendationsGridView.collectionView.addSubview(adsRetryView)
        adRecommendationsGridView.collectionView.addSubview(promoSlidesView)
        adRecommendationsGridView.collectionView.addSubview(marketsView)

        adRecommendationsGridView.collectionView.bringSubviewToFront(promoSlidesView)
        adRecommendationsGridView.collectionView.bringSubviewToFront(marketsView)

        NSLayoutConstraint.activate([
            promoViewTopConstraint,
            promoSlidesView.leadingAnchor.constraint(equalTo: adRecommendationsGridView.leadingAnchor),
            promoSlidesView.trailingAnchor.constraint(equalTo: adRecommendationsGridView.trailingAnchor),
            promoViewHeightConstraint,

            marketsView.topAnchor.constraint(equalTo: promoSlidesView.bottomAnchor),
            marketsView.leadingAnchor.constraint(equalTo: adRecommendationsGridView.leadingAnchor),
            marketsView.trailingAnchor.constraint(equalTo: adRecommendationsGridView.trailingAnchor),
            marketsViewHeightConstraint,

            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: .spacingM),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .spacingM),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -.spacingS),
        ])

        adRecommendationsGridView.headerView = headerView

        setupFrames()
    }

    private func setupFrames() {
        let marketsViewHeight = marketsView.calculateSize(constrainedTo: bounds.size.width).height
        marketsViewHeightConstraint.constant = marketsViewHeight
        adsRetryView.frame.origin = .zero
        adsRetryView.frame.size = CGSize(width: bounds.width, height: 200)
        boundsForCurrentSubviewSetup = bounds
        adRecommendationsGridView.invalidateLayout()
        adRecommendationsGridView.collectionView.contentInset.top = marketsViewHeight + promoViewHeightConstraint.constant

        let labelHeight = headerLabel.intrinsicContentSize.height + .spacingM + .spacingS
        headerView.frame.size.height = labelHeight
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
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        let maxOffset = promoViewHeightConstraint.constant

        let promoViewPercentageHidden: CGFloat
        if offset <= 0 {
            promoViewTopConstraint.constant = 0
            promoViewPercentageHidden = 0
        } else if offset >= maxOffset {
            promoViewTopConstraint.constant = -maxOffset
            promoViewPercentageHidden = 1
        } else {
            promoViewTopConstraint.constant = -offset
            promoViewPercentageHidden = offset / maxOffset
        }

        promoSlidesView.alpha = 1 - promoViewPercentageHidden
        delegate?.promotionFrontPageView(self, promoViewHiddenPercentage: promoViewPercentageHidden)

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
