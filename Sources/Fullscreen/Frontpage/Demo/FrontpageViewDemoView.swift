//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FrontpageViewDemoView: UIView {
    private let ads = AdFactory.create(numberOfModels: 9)
    private let markets = Market.allMarkets
    private var didSetupView = false

    private lazy var frontpageView: FrontpageView = {
        let view = FrontpageView(delegate: self)
        view.model = FrontpageViewDefaultData()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        }
    }

    private func setup() {
        addSubview(frontpageView)
        frontpageView.fillInSuperview()
        frontpageView.reloadMarkets()
        frontpageView.showInlineConsents(withText: "Vi kan vise deg relevante FINN-annonser du ikke har sett. Da trenger vi å lagre dine søkevalg.")
    }
}

// MARK: - AdsGridViewDelegate

extension FrontpageViewDemoView: FrontpageViewDelegate {
    public func frontpageViewDidSelectRetryButton(_ frontpageView: FrontpageView) {
        frontpageView.reloadData()
    }
}

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

// MARK: - InlineConsentViewDelegate

extension FrontpageViewDemoView: InlineConsentViewDelegate {
    public func inlineConsentView(_ inlineConsentView: InlineConsentView, didSelectYesButton button: Button) {
        frontpageView.hideInlineConsents()
        frontpageView.reloadAds()
    }

    public func inlineConsentView(_ inlineConsentView: InlineConsentView, didSelectInfoButton button: Button) {}
}
