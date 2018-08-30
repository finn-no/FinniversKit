//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FrontpageViewDemoView: UIView {
    fileprivate lazy var discoverGridView: AdsGridView = {
        let gridView = AdsGridView(delegate: self, dataSource: self)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()

    fileprivate lazy var marketGridView: MarketsGridView = {
        let marketGridView = MarketsGridView(delegate: self, dataSource: self)
        marketGridView.translatesAutoresizingMaskIntoConstraints = false
        return marketGridView
    }()

    fileprivate lazy var headerLabel: Label = {
        var headerLabel = Label(style: .title4)
        headerLabel.textColor = .licorice
        return headerLabel
    }()
    fileprivate lazy var headerView = UIView()

    fileprivate let ads = AdFactory.create(numberOfModels: 9)
    fileprivate let markets = Market.allMarkets

    // Makes sure ads grid view layout is calculated after we know how much space we have for its collection view
    private var didSetupView = false

    public override init(frame: CGRect) {
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

    private func setupView() {
        addSubview(discoverGridView)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Anbefalinger"

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

// MARK: - AdsGridViewDelegate

extension FrontpageViewDemoView: AdsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {}
    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}
}

// MARK: - AdsGridViewDataSource

extension FrontpageViewDemoView: AdsGridViewDataSource {
    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return ads.count
    }

    public func adsGridView(_ adsGridView: AdsGridView, modelAtIndex index: Int) -> AdsGridViewModel {
        return ads[index]
    }

    public func adsGridView(_ adsGridView: AdsGridView, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    public func adsGridView(_ adsGridView: AdsGridView, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat) {}
}

// MARK: - MarketsGridViewDelegate

extension FrontpageViewDemoView: MarketsGridViewDelegate {
    public func marketsGridView(_ marketsGridView: MarketsGridView, didSelectItemAtIndex index: Int) {}
}

// MARK: - MarketsGridViewDataSource

extension FrontpageViewDemoView: MarketsGridViewDataSource {
    public func numberOfItems(inMarketsGridView marketsGridView: MarketsGridView) -> Int {
        return markets.count
    }

    public func marketsGridView(_ marketsGridView: MarketsGridView, modelAtIndex index: Int) -> MarketsGridViewModel {
        return markets[index]
    }
}
