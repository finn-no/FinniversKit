//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoriteSoldViewModel {
    var adTitle: String { get }
    var adBody: String { get }
    var similarAdsTitle: String { get }
}

public class FavoriteSoldView: UIView {
    public var model: FavoriteSoldViewModel? {
        didSet {
            adTitleLabel.text = model?.adTitle
            adBodyLabel.text = model?.adBody
            similarAdsTitleLabel.text = model?.similarAdsTitle
        }
    }

    // MARK: - Private properties

    private static let margins: CGFloat = .spacingM
    private static let adTitleTopSpacing: CGFloat = .spacingXL
    private static let adBodyTopSpacing: CGFloat = .spacingS
    private static let similarAdsTitleTopSpacing: CGFloat = .spacingXXL
    private static let adsGridTopSpacing: CGFloat = .spacingXL

    private var didSetupView = false
    private var boundsForCurrentSubviewSetup = CGRect.zero

    // MARK: - Subviews

    private lazy var adTitleLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var adBodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var similarAdsTitleLabel: Label = {
        let label = Label(style: .title3, withAutoLayout: true)
        return label
    }()

    private let adsGridView: AdsGridView

    private lazy var headerView = UIView()

    // MARK: - Init

    public convenience init(delegate: AdsGridViewDelegate & AdsGridViewDataSource) {
        self.init(adsGridViewDelegate: delegate, adsGridViewDataSource: delegate)
    }

    init(adsGridViewDelegate: AdsGridViewDelegate, adsGridViewDataSource: AdsGridViewDataSource) {
        adsGridView = AdsGridView(delegate: adsGridViewDelegate, dataSource: adsGridViewDataSource)
        adsGridView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        } else if !boundsForCurrentSubviewSetup.equalTo(bounds) {
            setupFrames()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(adsGridView)

        headerView.addSubview(adTitleLabel)
        headerView.addSubview(adBodyLabel)
        headerView.addSubview(similarAdsTitleLabel)

        NSLayoutConstraint.activate([
            adTitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: FavoriteSoldView.adTitleTopSpacing),
            adTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: FavoriteSoldView.margins),
            adTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -FavoriteSoldView.margins),

            adBodyLabel.topAnchor.constraint(equalTo: adTitleLabel.bottomAnchor, constant: FavoriteSoldView.adBodyTopSpacing),
            adBodyLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: FavoriteSoldView.margins),
            adBodyLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -FavoriteSoldView.margins),

            similarAdsTitleLabel.topAnchor.constraint(equalTo: adBodyLabel.bottomAnchor, constant: FavoriteSoldView.similarAdsTitleTopSpacing),
            similarAdsTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: FavoriteSoldView.margins),
            similarAdsTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -FavoriteSoldView.margins),
        ])

        adsGridView.fillInSuperview()
        adsGridView.headerView = headerView
        setupFrames()
    }

    private func setupFrames() {
        let adTitleLabelHeight = adTitleLabel.intrinsicContentSize.height
        let adBodyLabelHeight = adBodyLabel.intrinsicContentSize.height
        let similarAdsTitleHeight = similarAdsTitleLabel.intrinsicContentSize.height

        let height = FavoriteSoldView.adTitleTopSpacing + adTitleLabelHeight +
            FavoriteSoldView.adBodyTopSpacing + adBodyLabelHeight +
            FavoriteSoldView.similarAdsTitleTopSpacing + similarAdsTitleHeight +
            FavoriteSoldView.adsGridTopSpacing

        headerView.frame.size.height = height
        boundsForCurrentSubviewSetup = bounds
        adsGridView.invalidateLayout()
    }

    // MARK: - Public methods

    public func reloadAds() {
        adsGridView.reloadData()
    }

}
