//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FrontpageGridView: UIView {
    var marketsGridViewDelegate: MarketsGridViewDelegate
    var marketsGridViewDataSource: MarketsGridViewDataSource
    var adsGridViewDelegate: AdsGridViewDelegate
    var adsGridViewDataSource: AdsGridViewDataSource

    fileprivate lazy var discoverGridView: AdsGridView = {
        let gridView = AdsGridView(delegate: self.adsGridViewDelegate, dataSource: self.adsGridViewDataSource)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()

    fileprivate lazy var marketGridView: MarketsGridView = {
        let marketGridView = MarketsGridView(delegate: self.marketsGridViewDelegate, dataSource: self.marketsGridViewDataSource)
        marketGridView.translatesAutoresizingMaskIntoConstraints = false
        return marketGridView
    }()

    fileprivate lazy var headerLabel = Label(style: .title4(.licorice))
    fileprivate lazy var headerView = UIView()

    // Makes sure ads grid view layout is calculated after we know how much space we have for its collection view
    private var didSetupView = false

    public init(frame: CGRect = .zero, marketsGridViewDelegate: MarketsGridViewDelegate, marketsGridViewDataSource: MarketsGridViewDataSource, adsGridViewHeaderTitle: String, adsGridViewDelegate: AdsGridViewDelegate, adsGridViewDataSource: AdsGridViewDataSource) {
        self.marketsGridViewDelegate = marketsGridViewDelegate
        self.marketsGridViewDataSource = marketsGridViewDataSource

        self.adsGridViewHeaderTitle = adsGridViewHeaderTitle
        self.adsGridViewDelegate = adsGridViewDelegate
        self.adsGridViewDataSource = adsGridViewDataSource

        super.init(frame: frame)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setupView()
            didSetupView = true
        }
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public var adsGridViewHeaderTitle: String

    public func reloadData() {
        discoverGridView.reloadData()
        marketGridView.reloadData()
    }

    public func invalidateLayout() {
        discoverGridView.invalidateLayout()
        marketGridView.invalidateLayout()
    }
}

extension FrontpageGridView {
    private func setupView() {
        addSubview(discoverGridView)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = adsGridViewHeaderTitle

        headerView.addSubview(headerLabel)
        headerView.addSubview(marketGridView)

        NSLayoutConstraint.activate([
            discoverGridView.topAnchor.constraint(equalTo: topAnchor),
            discoverGridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            discoverGridView.bottomAnchor.constraint(equalTo: bottomAnchor),
            discoverGridView.leadingAnchor.constraint(equalTo: leadingAnchor),

            marketGridView.topAnchor.constraint(equalTo: headerView.topAnchor),
            marketGridView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            marketGridView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            headerLabel.topAnchor.constraint(equalTo: marketGridView.bottomAnchor, constant: .largeSpacing),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -.mediumLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: .mediumLargeSpacing),
        ])

        let height = calculateAdsHeaderHeight()
        headerView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: height)

        discoverGridView.headerView = headerView
    }

    private func calculateAdsHeaderHeight() -> CGFloat {
        let headerTopSpacing: CGFloat = .largeSpacing
        let headerBottomSpacing: CGFloat = .mediumLargeSpacing
        let headerHeight = headerLabel.intrinsicContentSize.height
        let marketGridViewHeight = marketGridView.calculateSize(constrainedTo: frame.size.width).height
        return headerTopSpacing + headerBottomSpacing + headerHeight + marketGridViewHeight
    }
}
