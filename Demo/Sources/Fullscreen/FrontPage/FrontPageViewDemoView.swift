//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FrontpageViewDemoView: UIView, Tweakable {
    private let markets = Market.allMarkets
    private var didSetupView = false
    private var visibleItems = 20

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "No promo"),
            TweakingOption(title: "Promo link", action: {
                self.frontPageView.setupPromoLinkView(with: PromoViewModel())
            }),
            TweakingOption(title: "Motor transaction entry", action: {
                self.frontPageView.setupTransactionEntry(with: MotorTransactionEntryViewModel())
            })
        ]
    }()

    private let ads: [Ad] = {
        var ads = AdFactory.create(numberOfModels: 120)
        ads.insert(AdFactory.googleDemoAd, at: 4)
        return ads
    }()

    private lazy var frontPageView: FrontPageView = {
        let view = FrontPageView(delegate: self, adRecommendationsGridViewDataSource: self, remoteImageViewDataSource: self)
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

    private func loadImage(imagePath: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
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
}

// MARK: - AdRecommendationsGridViewDelegate

extension FrontpageViewDemoView: FrontPageViewDelegate {
    public func frontPageViewDidSelectRetryButton(_ frontPageView: FrontPageView) {
        frontPageView.reloadData()
    }
}

extension FrontpageViewDemoView: AdRecommendationsGridViewDelegate {
    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.frontPageView.reloadAds()
            })
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}

    public func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {
        frontPageView.reloadData()
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adRecommendationsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdRecommendationsGridViewDataSource

extension FrontpageViewDemoView: AdRecommendationsGridViewDataSource {
    public func numberOfColumns(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        return nil
    }

    public func numberOfItems(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            StandardAdRecommendationCell.self,
            BannerAdDemoCell.self
        ]
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = ads[indexPath.item]

        switch model.adType {
        case .google:
            return 300
        default:
            return StandardAdRecommendationCell.height(
                for: model,
                width: width
            )
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = ads[indexPath.item]

        switch model.adType {
        case .google:
            return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)

        default:
            let cell = collectionView.dequeue(StandardAdRecommendationCell.self, for: indexPath)
            cell.imageDataSource = adRecommendationsGridView
            cell.delegate = adRecommendationsGridView
            cell.configure(with: model, atIndex: indexPath.item)
            return cell
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        loadImage(imagePath: imagePath, completion: completion)
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - MarketsGridViewDelegate

extension FrontpageViewDemoView: MarketsViewDelegate {
    public func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {}
}

// MARK: - MarketsGridViewDataSource

extension FrontpageViewDemoView: MarketsViewDataSource {
    public func numberOfItems(inMarketsView marketsView: MarketsView) -> Int {
        return markets.count
    }

    public func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel {
        return markets[index]
    }
}

extension FrontpageViewDemoView: PromoLinkViewDelegate {
    public func promoLinkViewWasTapped(_ promoLinkView: PromoLinkView) {
        print("Tapped promo link!")
    }
}

extension FrontpageViewDemoView: TransactionEntryViewDelegate {
    public func transactionEntryViewWasTapped(_ transactionEntryView: TransactionEntryView) {
        print("Tapped transaction entry!")
    }
}

extension FrontpageViewDemoView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        loadImage(imagePath: imagePath, completion: completion)
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

private class PromoViewModel: PromoLinkViewModel {
    var title = "Smidig bilhandel? Prøv FINNs nye prosess!"
    var image = UIImage(named: .transactionJourneyCar)
}

private class MotorTransactionEntryViewModel: TransactionEntryViewModel {
    var title: String = "Kontrakt"
    var text: String = "Kjøper har signert, nå mangler bare din signatur."
    var imageUrl: String? = "https://finn-content-hub.imgix.net/bilder/Motor/Toma%CC%8Aterbil_Toppbilde.jpg?auto=compress&crop=focalpoint&domain=finn-content-hub.imgix.net&fit=crop&fm=jpg&fp-x=0.5&fp-y=0.5&h=900&ixlib=php-3.3.0&w=1600"
    var showWarningIcon: Bool = false
    var fallbackImage: UIImage = UIImage(named: .transactionJourneyCar)
}
