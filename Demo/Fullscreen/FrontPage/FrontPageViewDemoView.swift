//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FrontpageViewDemoView: UIView {
    private let ads = AdFactory.create(numberOfModels: 120)
    private let markets = Market.allMarkets
    private var didSetupView = false
    private var visibleItems = 20

    private lazy var frontPageView: FrontPageView = {
        let view = FrontPageView(delegate: self)
        view.model = FrontpageViewDefaultData()
        view.isRefreshEnabled = true
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
        addSubview(frontPageView)
        frontPageView.fillInSuperview()
        frontPageView.reloadData()
    }
}

// MARK: - AdsGridViewDelegate

extension FrontpageViewDemoView: FrontPageViewDelegate {
    public func frontPageViewDidSelectRetryButton(_ frontPageView: FrontPageView) {
        frontPageView.reloadData()
    }
}

extension FrontpageViewDemoView: AdsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.frontPageView.reloadAds()
            })
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}

    public func adsGridViewDidStartRefreshing(_ adsGridView: AdsGridView) {
        frontPageView.reloadData()
    }

    public func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdsGridViewCell, at index: Int) {
        adsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdsGridViewDataSource

extension FrontpageViewDemoView: AdsGridViewDataSource {
    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    public func adsGridView(_ adsGridView: AdsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            AdsGridViewCell.self
        ]
    }

    public func adsGridView(_ adsGridView: AdsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        return AdsGridViewCell.height(
            for: ads[indexPath.item],
            width: width
        )
    }

    public func adsGridView(_ adsGridView: AdsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(AdsGridViewCell.self, for: indexPath)
        // Show a pretty color while we load the image
        let colors: [UIColor] = [.toothPaste, .mint, .banana, .salmon]
        let color = colors[indexPath.row % 4]

        cell.index = indexPath.row
        cell.loadingColor = color
        cell.dataSource = adsGridView
        cell.delegate = adsGridView
        cell.model = ads[indexPath.item]

        return cell
    }

    public func adsGridView(_ adsGridView: AdsGridView, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((AdsGridViewModel, UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(model, nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(model, image)
                } else {
                    completion(model, nil)
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

// MARK: - DialogueViewDelegate

extension FrontpageViewDemoView: DialogueViewDelegate {
    public func dialogueViewDidSelectLink() {}
    public func dialogueViewDidSelectPrimaryButton() {
        frontPageView.hideInlineConsent()
        frontPageView.reloadAds()
    }
}
