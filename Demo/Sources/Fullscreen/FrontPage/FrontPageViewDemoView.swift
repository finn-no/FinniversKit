//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class FrontpageViewDemoView: UIView, Demoable {

    var presentation: DemoablePresentation { .navigationController }

    private let markets = Market.newMarkets
    private var didSetupView = false
    private var visibleItems = 20

    private let ads: [Ad] = {
        var ads = AdFactory.create(numberOfModels: 120)
        ads.insert(AdFactory.googleDemoAd, at: 4)
        return ads
    }()

    private lazy var frontPageView: FrontPageView = {
        let view = FrontPageView(delegate: self, marketsViewDataSource: self, adRecommendationsGridViewDataSource: self, remoteImageViewDataSource: self)
        view.model = FrontpageViewDefaultData()
        view.isRefreshEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let hjerteromPromoViewModel = PromotionViewModel(
            title: "Hjerterom - hjelp til flyktninger",
            text: "Under Hjerterom kan du finne informasjon om hvordan du kan hjelpe flyktninger som kommer til Norge.",
            image: UIImage(named: .hjerterom),
            imageAlignment: .fullWidth,
            imageBackgroundColor: .btnAction,
            primaryButtonTitle: "Gå til Hjerterom"
        )
        view.showPromotion(withViewModel: hjerteromPromoViewModel, andDelegate: self)

        let savedSearchesViewModel = FrontPageSavedSearchesViewModel(
            searchViewModels: FrontPageSavedSearchFactory.create(numberOfItems: 10),
            title: "Nytt i lagrede søk",
            buttonTitle: "Se alle"
        )
        view.configure(
            withSavedSearches: savedSearchesViewModel,
            firstVisibleSavedSearchIndex: 1,
            remoteImageViewDataSource: self
        )
        view.savedSearchesViewDelegate = self

        let transactionViewModel = FrontPageTransactionViewModel(
            headerTitle: "Dine handler på torget",
            title: "Flotte lamper med gull greier",
            subtitle: "Velg en kjøper",
            imageUrl: "https://images.finncdn.no/dynamic/960w/2021/4/vertical-0/11/5/214/625/615_1292134726.jpg",
            adId: 1234,
            transactionId: nil
        )

        view.showTransactionFeed(withViewModel: transactionViewModel, andDelegate: self)

        return view
    }()

    // MARK: - Setup

    override func layoutSubviews() {
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

// MARK: - PromotionViewDelegate

extension FrontpageViewDemoView: PromotionViewDelegate {
    func promotionViewTapped(_ promotionView: PromotionView) {
        print("Promo tapped")
    }

    func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action) {
        print("Selected : \(action)")
    }
}

// MARK: - AdRecommendationsGridViewDelegate

extension FrontpageViewDemoView: FrontPageViewDelegate {
    func frontPageViewDidSelectRetryButton(_ frontPageView: FrontPageView) {
        frontPageView.reloadData()
    }
}

extension FrontpageViewDemoView: AdRecommendationsGridViewDelegate {
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.frontPageView.reloadAds()
            })
        }
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}

    func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {
        frontPageView.reloadData()
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adRecommendationsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdRecommendationsGridViewDataSource

extension FrontpageViewDemoView: AdRecommendationsGridViewDataSource {
    func numberOfColumns(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        return nil
    }

    func numberOfItems(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            StandardAdRecommendationCell.self,
            BannerAdDemoCell.self
        ]
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
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

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        loadImage(imagePath: imagePath, completion: completion)
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - MarketsGridViewDelegate

extension FrontpageViewDemoView: MarketsViewDelegate {
    func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {}
}

// MARK: - MarketsGridViewDataSource

extension FrontpageViewDemoView: MarketsViewDataSource {
    func numberOfItems(inMarketsView marketsView: MarketsView) -> Int {
        return markets.count
    }

    func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel {
        return markets[index]
    }
}

// MARK: - RemoteImageViewDataSource

extension FrontpageViewDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        loadImage(imagePath: imagePath, completion: completion)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontpageViewDemoView: FrontPageSavedSearchesViewDelegate {
    func frontPageSavedSearchesView(_ view: FrontPageSavedSearchesView, didSelectSavedSearch savedSearch: FrontPageSavedSearchViewModel) {
        print("Did select saved search with title", savedSearch.title)
    }

    func frontPageSavedSearchesViewDidSelectActionButton(_ view: FrontPageSavedSearchesView) {
        print("Did select action button")
    }
}

// MARK: - FrontPageTransactionFeedDelegate

extension FrontpageViewDemoView: FrontPageTransactionViewDelegate {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView) {
        print("TransactionFeedView tapped")
    }
}
