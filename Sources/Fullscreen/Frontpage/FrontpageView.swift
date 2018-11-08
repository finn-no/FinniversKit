//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol FrontpageViewDelegate: AnyObject {
    func frontpageViewDidSelectRetryButton(_ frontpageView: FrontpageView)
}

public final class FrontpageView: UIView {
    private weak var delegate: FrontpageViewDelegate?
    private let adsGridViewHeaderTitle: String
    private let retryButtonTitle: String

    private let marketsGridView: MarketsGridView
    private let adsGridView: AdsGridView
    private lazy var headerView = UIView()

    private lazy var headerLabel: Label = {
        var headerLabel = Label(style: .title3)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = self.adsGridViewHeaderTitle
        return headerLabel
    }()

    private lazy var adsLoadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = .primaryBlue
        return indicatorView
    }()

    private lazy var adsRetryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(self.retryButtonTitle, for: .normal)
        button.setTitleColor(.primaryBlue, for: .normal)
        button.addTarget(self, action: #selector(handleAdsRetryButtonTap), for: .touchUpInside)
        button.titleLabel?.font = .body
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        button.isHidden = true
        return button
    }()

    // MARK: - Init

    public init(viewModel: FrontpageViewModel) {
        self.adsGridViewHeaderTitle = viewModel.adsGridViewHeaderTitle
        self.retryButtonTitle = viewModel.retryButtonTitle

        marketsGridView = MarketsGridView(delegate: viewModel.marketsGridViewDelegate, dataSource: viewModel.marketsGridViewDataSource)
        marketsGridView.translatesAutoresizingMaskIntoConstraints = false

        adsGridView = AdsGridView(delegate: viewModel.adsGridViewDelegate, dataSource: viewModel.adsGridViewDataSource)
        adsGridView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func reloadMarkets() {
        marketsGridView.reloadData()
        setupAdsHeaderFrame()
        setupAdsRetryButton()
        adsGridView.reloadData()
    }

    public func reloadAds() {
        adsRetryButton.isHidden = true
        adsLoadingIndicatorView.stopAnimating()
        adsGridView.reloadData()
    }

    public func showAdsRetryButton() {
        adsRetryButton.isHidden = false
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
        addSubview(adsRetryButton)
        addSubview(adsLoadingIndicatorView)

        headerView.addSubview(headerLabel)
        headerView.addSubview(marketsGridView)

        NSLayoutConstraint.activate([
            marketsGridView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: .mediumLargeSpacing),
            marketsGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketsGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: marketsGridView.bottomAnchor, constant: .mediumLargeSpacing),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -.mediumSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: .mediumLargeSpacing),

            adsLoadingIndicatorView.centerXAnchor.constraint(equalTo: adsRetryButton.centerXAnchor),
            adsLoadingIndicatorView.centerYAnchor.constraint(equalTo: adsRetryButton.centerYAnchor)
        ])

        adsGridView.fillInSuperview()
        adsGridView.headerView = headerView

        setupAdsHeaderFrame()
        setupAdsRetryButton()
    }

    private func setupAdsHeaderFrame() {
        let headerTopSpacing: CGFloat = .largeSpacing
        let headerBottomSpacing: CGFloat = .mediumLargeSpacing
        let headerHeight = headerLabel.intrinsicContentSize.height
        let marketGridViewHeight = marketsGridView.calculateSize(constrainedTo: frame.size.width).height
        let height = headerTopSpacing + headerBottomSpacing + headerHeight + marketGridViewHeight

        headerView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: height)
    }

    private func setupAdsRetryButton() {
        adsRetryButton.sizeToFit()

        let xCoordinate = (bounds.width - adsRetryButton.frame.width) / 2
        let yCoordinate = (bounds.height - headerView.frame.height) / 2

        adsRetryButton.frame.origin = CGPoint(x: xCoordinate, y: yCoordinate)
    }

    // MARK: - Actions

    @objc private func handleAdsRetryButtonTap() {
        adsRetryButton.isHidden = true
        adsLoadingIndicatorView.startAnimating()
        delegate?.frontpageViewDidSelectRetryButton(self)
    }
}
