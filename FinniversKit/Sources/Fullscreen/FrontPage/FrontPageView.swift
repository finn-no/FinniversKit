//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol FrontPageViewModel {
    var adRecommedationsGridViewHeaderTitle: String { get }
    var retryButtonTitle: String { get }
    var noRecommendationsText: String { get }
}

public protocol ABTestViewModel {
    var activeTestVariant: FrontPageView.ABTestVariant { get }
    var slides: [UIView] { get }
    var promoLinkViewModel: PromoLinkViewModel { get }
}

public protocol FrontPageViewDelegate: AnyObject {
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

    private weak var delegate: FrontPageViewDelegate?
    private var didSetupView = false

    // MARK: - Subviews

    private let marketsGridView: MarketsGridView
    private let adRecommendationsGridView: AdRecommendationsGridView

    private let promoContainer = UIView(withAutoLayout: true)
    private var promoLinkView: PromoLinkView?
    private weak var promoLinkViewDelegate: PromoLinkViewDelegate?

    private lazy var promoSliderView: PromoSliderView = {
        let view = PromoSliderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var headerView = UIView()

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

    private lazy var marketsGridViewHeight = self.marketsGridView.heightAnchor.constraint(equalToConstant: 0)

    private var keyValueObservation: NSKeyValueObservation?

    private var boundsForCurrentSubviewSetup = CGRect.zero

    private let abTestViewModel: ABTestViewModel

    public enum ABTestVariant {
        case traditional
        case simplePromo
        case redesign
    }

    private let abTestVariant: ABTestVariant

    // MARK: - Init

    public convenience init(abTestViewModel: ABTestViewModel, delegate: FrontPageViewDelegate & MarketsGridViewDelegate & MarketsGridViewDataSource & AdRecommendationsGridViewDelegate & PromoLinkViewDelegate, adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource) {
        self.init(abTestViewModel: abTestViewModel, delegate: delegate, marketsGridViewDelegate: delegate, marketsGridViewDataSource: delegate, adRecommendationsGridViewDelegate: delegate, adRecommendationsGridViewDataSource: adRecommendationsGridViewDataSource, promoLinkViewDelegate: delegate)
    }

    public init(
        abTestViewModel: ABTestViewModel,
        delegate: FrontPageViewDelegate,
        marketsGridViewDelegate: MarketsGridViewDelegate,
        marketsGridViewDataSource: MarketsGridViewDataSource,
        adRecommendationsGridViewDelegate: AdRecommendationsGridViewDelegate,
        adRecommendationsGridViewDataSource: AdRecommendationsGridViewDataSource,
        promoLinkViewDelegate: PromoLinkViewDelegate
    ) {
        marketsGridView = MarketsGridView(delegate: marketsGridViewDelegate, dataSource: marketsGridViewDataSource)
        marketsGridView.translatesAutoresizingMaskIntoConstraints = false

        adRecommendationsGridView = AdRecommendationsGridView(delegate: adRecommendationsGridViewDelegate, dataSource: adRecommendationsGridViewDataSource)
        adRecommendationsGridView.translatesAutoresizingMaskIntoConstraints = false

        self.abTestViewModel = abTestViewModel
        abTestVariant = abTestViewModel.activeTestVariant

        super.init(frame: .zero)
        self.delegate = delegate
        self.promoLinkViewDelegate = promoLinkViewDelegate
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
        setupFrames()
        reloadAds()
    }

    public func reloadMarkets() {
        marketsGridView.reloadData()
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

        addSubview(adRecommendationsGridView)

        adRecommendationsGridView.collectionView.addSubview(adsRetryView)

        if abTestVariant == .redesign {
            setupRedesign()
            return
        }

        headerView.addSubview(marketsGridView)
        headerView.addSubview(promoContainer)
        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            marketsGridView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: .spacingM),
            marketsGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketsGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            marketsGridViewHeight,

            promoContainer.topAnchor.constraint(equalTo: marketsGridView.bottomAnchor),
            promoContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            promoContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: promoContainer.bottomAnchor, constant: .spacingM),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .spacingM),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -.spacingM),
        ])

        if abTestVariant == .simplePromo {
            setupSimplePromo()
        }

        adRecommendationsGridView.fillInSuperview()
        adRecommendationsGridView.headerView = headerView

        setupFrames()
    }

    private func setupRedesign() {
        guard abTestVariant == .redesign else { return }

        promoSliderView.configure(withSlides: abTestViewModel.slides)
        promoSliderView.reloadData()

        headerView.addSubview(promoSliderView)
        headerView.addSubview(headerLabel)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        promoSliderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            promoSliderView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            promoSliderView.topAnchor.constraint(equalTo: headerView.topAnchor),
            promoSliderView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .spacingM),
            headerLabel.topAnchor.constraint(equalTo: promoSliderView.bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -.spacingM),
            headerLabel.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor)
        ])

        adRecommendationsGridView.fillInSuperview()
        adRecommendationsGridView.headerView = headerView

        setupFramesForRedesign()
    }

    private func setupSimplePromo() {
        guard abTestVariant == .simplePromo else { return }

        promoLinkView = PromoLinkView(delegate: promoLinkViewDelegate)

        guard let promoLinkView = promoLinkView else { return }

        promoLinkView.translatesAutoresizingMaskIntoConstraints = false
        promoLinkView.configure(with: abTestViewModel.promoLinkViewModel)

        promoContainer.addSubview(promoLinkView)

        NSLayoutConstraint.activate([
            promoLinkView.topAnchor.constraint(equalTo: promoContainer.topAnchor, constant: .spacingM),
            promoLinkView.leadingAnchor.constraint(equalTo: promoContainer.leadingAnchor, constant: .spacingM),
            promoLinkView.trailingAnchor.constraint(equalTo: promoContainer.trailingAnchor, constant: -.spacingM),
            promoLinkView.bottomAnchor.constraint(equalTo: promoContainer.bottomAnchor)
        ])
    }

    private func setupFrames() {
        if abTestVariant == .redesign {
            setupFramesForRedesign()
            return
        }

        let headerTopSpacing: CGFloat = .spacingM
        let headerBottomSpacing: CGFloat = .spacingS
        let labelHeight = headerLabel.intrinsicContentSize.height + .spacingM
        let promoContainerHeight = promoContainer
            .systemLayoutSizeFitting(
                CGSize(width: bounds.size.width, height: 0),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
            .height

        let marketGridViewHeight = marketsGridView.calculateSize(constrainedTo: bounds.size.width).height + .spacingXS
        let height = headerTopSpacing + labelHeight + marketGridViewHeight + promoContainerHeight + headerBottomSpacing

        marketsGridViewHeight.constant = marketGridViewHeight
        headerView.frame.size.height = height
        adsRetryView.frame.origin = CGPoint(x: 0, y: headerView.frame.height + .spacingXXL)
        adsRetryView.frame.size = CGSize(width: bounds.width, height: 200)
        boundsForCurrentSubviewSetup = bounds
        adRecommendationsGridView.invalidateLayout()
    }

    private func setupFramesForRedesign() {
        guard abTestVariant == .redesign else { return }

        promoSliderView.updateFramesIfNecessary()

        let promoHeight = promoSliderView
            .systemLayoutSizeFitting(
                CGSize(width: bounds.size.width, height: 0),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
            .height

        let labelHeight = headerLabel.intrinsicContentSize.height + .spacingM

        let height = promoHeight + labelHeight

        headerView.frame.size.height = height
        adsRetryView.frame.origin = CGPoint(x: 0, y: headerView.frame.height + .spacingXXL)
        boundsForCurrentSubviewSetup = bounds
        adRecommendationsGridView.invalidateLayout()
    }
}

// MARK: - LoadingRetryViewDelegate

extension FrontPageView: LoadingRetryViewDelegate {
    func loadingRetryViewDidSelectButton(_ view: LoadingRetryView) {
        adsRetryView.state = .loading
        delegate?.frontPageViewDidSelectRetryButton(self)
    }
}
