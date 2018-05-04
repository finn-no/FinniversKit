//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FrontpageDataSource: NSObject {
    let ads = AdFactory.create(numberOfModels: 9)
    let markets = Market.allMarkets
}

public class FrontpageGridViewDemoView: UIView {
    lazy var dataSource: FrontpageDataSource = {
        return FrontpageDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let collectionView = FrontpageGridView(marketsGridViewDelegate: self, marketsGridViewDataSource: self, adsGridViewHeaderTitle: "Anbefalinger", adsGridViewDelegate: self, adsGridViewDataSource: self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
}

// MARK: - MarketsGridViewDataSource

extension FrontpageGridViewDemoView: MarketsGridViewDataSource {
    public func numberOfItems(inMarketsGridView marketsGridView: MarketsGridView) -> Int {
        return dataSource.markets.count
    }

    public func marketsGridView(_ marketsGridView: MarketsGridView, modelAtIndex index: Int) -> MarketsGridViewModel {
        return dataSource.markets[index]
    }
}

// MARK: - MarketsGridViewDelegate

extension FrontpageGridViewDemoView: MarketsGridViewDelegate {
    public func marketsGridView(_ marketsGridView: MarketsGridView, didSelectItemAtIndex index: Int) {}
}

// MARK: - AdsGridViewDataSource

extension FrontpageGridViewDemoView: AdsGridViewDataSource {
    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return dataSource.ads.count
    }

    public func adsGridView(_ adsGridView: AdsGridView, modelAtIndex index: Int) -> AdsGridViewModel {
        return dataSource.ads[index]
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

// MARK: - AdsGridViewDelegate

extension FrontpageGridViewDemoView: AdsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {}
    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}
}
