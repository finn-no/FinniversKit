//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FrontpageGridViewDemoView: UIView {
    var ads = [Ad]()
    var markets = [Market]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    lazy var collectionView: FrontpageGridView = {
        let collectionView = FrontpageGridView(marketsGridViewDelegate: self, marketsGridViewDataSource: self, adsGridViewHeaderTitle: "Anbefalinger", adsGridViewDelegate: self, adsGridViewDataSource: self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()

        perform(#selector(self.fillData), with: nil, afterDelay: 2)
    }

    @objc func fillData() {
        ads = AdFactory.create(numberOfModels: 9)
        markets = Market.allMarkets
        collectionView.reloadData()
    }
}

// MARK: - MarketsGridViewDataSource

extension FrontpageGridViewDemoView: MarketsGridViewDataSource {
    public func numberOfItems(inMarketsGridView marketsGridView: MarketsGridView) -> Int {
        return markets.count
    }

    public func marketsGridView(_ marketsGridView: MarketsGridView, modelAtIndex index: Int) -> MarketsGridViewModel {
        return markets[index]
    }
}

// MARK: - MarketsGridViewDelegate

extension FrontpageGridViewDemoView: MarketsGridViewDelegate {
    public func marketsGridView(_ marketsGridView: MarketsGridView, didSelectItemAtIndex index: Int) {}
}

// MARK: - AdsGridViewDataSource

extension FrontpageGridViewDemoView: AdsGridViewDataSource {
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

// MARK: - AdsGridViewDelegate

extension FrontpageGridViewDemoView: AdsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {}
    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}
}
