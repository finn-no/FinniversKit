//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol FrontpageViewDelegate: AnyObject {
    func frontpageViewDidSelectRetryButton(_ frontpageView: FrontpageView)
}

public final class FrontpageView: UIView {
    public var model: FrontpageViewModel? {
        didSet {
            headerLabel.text = model?.adsGridViewHeaderTitle
            adsRetryView.set(labelText: model?.noRecommendationsText, buttonText: model?.retryButtonTitle)
            inlineConsentView.yesButtonTitle = model?.inlineConsentYesButtonTitle ?? ""
            inlineConsentView.infoButtonTitle = model?.inlineConsentInfoButtonTitle ?? ""
        }
    }

    private weak var delegate: FrontpageViewDelegate?
    private var didSetupView = false

    // MARK: - Subviews

    private let marketsGridView: MarketsGridView
    private let adsGridView: AdsGridView
    private lazy var headerView = UIView()

    private lazy var inlineConsentView: InlineConsentView = {
        let view = InlineConsentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var headerLabel: Label = {
        var headerLabel = Label(style: .title3)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()

    private lazy var adsRetryView: FrontpageRetryView = {
        let view = FrontpageRetryView()
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public convenience init(delegate: FrontpageViewDelegate & MarketsGridViewDelegate & MarketsGridViewDataSource & AdsGridViewDelegate & AdsGridViewDataSource) {
        self.init(delegate: delegate, marketsGridViewDelegate: delegate, marketsGridViewDataSource: delegate, adsGridViewDelegate: delegate, adsGridViewDataSource: delegate)
    }

    public init(delegate: FrontpageViewDelegate, marketsGridViewDelegate: MarketsGridViewDelegate, marketsGridViewDataSource: MarketsGridViewDataSource, adsGridViewDelegate: AdsGridViewDelegate, adsGridViewDataSource: AdsGridViewDataSource) {
        marketsGridView = MarketsGridView(delegate: marketsGridViewDelegate, dataSource: marketsGridViewDataSource)
        marketsGridView.translatesAutoresizingMaskIntoConstraints = false

        adsGridView = AdsGridView(delegate: adsGridViewDelegate, dataSource: adsGridViewDataSource)
        adsGridView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)
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
        }
    }

    public func reloadData() {
        reloadMarkets()
        reloadAds()
    }

    public func reloadMarkets() {
        marketsGridView.reloadData()
        setupAdsHeaderFrame()
        adsGridView.reloadData()
        setupAdsRetryView()
    }

    public func reloadAds() {
        adsRetryView.state = .hidden
        adsGridView.reloadData()
    }

    public func showAdsRetryButton() {
        adsRetryView.state = .labelAndButton
    }

    public func showInlineConsents(withText text: String) {
        adsGridView.collectionView.isScrollEnabled = false
        inlineConsentView.isHidden = false
        inlineConsentView.descriptionText = text
    }

    public func hideInlineConsents() {
        adsGridView.collectionView.isScrollEnabled = true
        inlineConsentView.isHidden = true
        inlineConsentView.descriptionText = ""
    }

    public func invalidateLayout() {
        adsGridView.invalidateLayout()
    }

    public func scrollToTop() {
        adsGridView.scrollToTop()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .milk

        addSubview(adsGridView)
        addSubview(adsRetryView)
        addSubview(inlineConsentView)

        headerView.addSubview(headerLabel)
        headerView.addSubview(marketsGridView)

        let maxInlineConsentViewWidth: CGFloat = 414.0
        let inlineConsentViewWidth = inlineConsentView.widthAnchor.constraint(equalToConstant: maxInlineConsentViewWidth)
        inlineConsentViewWidth.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            marketsGridView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: .mediumLargeSpacing),
            marketsGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketsGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: marketsGridView.bottomAnchor, constant: .mediumLargeSpacing),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -.mediumSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -.mediumLargeSpacing),

            inlineConsentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            inlineConsentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inlineConsentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumLargeSpacing),
            inlineConsentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),
            inlineConsentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            inlineConsentViewWidth
        ])

        adsGridView.fillInSuperview()
        adsGridView.headerView = headerView

        setupAdsHeaderFrame()
        setupAdsRetryView()
    }

    private func setupAdsHeaderFrame() {
        let headerTopSpacing: CGFloat = .largeSpacing
        let headerBottomSpacing: CGFloat = .mediumLargeSpacing
        let headerHeight = headerLabel.intrinsicContentSize.height
        let marketGridViewHeight = marketsGridView.calculateSize(constrainedTo: bounds.size.width).height
        let height = headerTopSpacing + headerBottomSpacing + headerHeight + marketGridViewHeight

        headerView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: height)
    }

    private func setupAdsRetryView() {
        let yCoordinate = headerView.bounds.height + .veryLargeSpacing
        adsRetryView.frame.size.height = 200
        adsRetryView.frame.size.width = bounds.width
        adsRetryView.frame.origin = CGPoint(x: 0, y: yCoordinate)
    }
}

// MARK: - FrontpageRetryViewDelegate

extension FrontpageView: FrontpageRetryViewDelegate {
    func frontpageRetryViewDidSelectButton(_ view: FrontpageRetryView) {
        adsRetryView.state = .loading
        delegate?.frontpageViewDidSelectRetryButton(self)
    }
}
