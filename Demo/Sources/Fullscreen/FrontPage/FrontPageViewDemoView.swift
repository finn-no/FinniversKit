import FinniversKit

public class FrontpageViewDemoView: UIView {
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

        view.showTransactionFeed(withViewModels: [.tjtRegular, .tjmRegular], andDelegate: self)

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

// MARK: - PromotionViewDelegate

extension FrontpageViewDemoView: PromotionViewDelegate {
    public func promotionViewTapped(_ promotionView: PromotionView) {
        print("Promo tapped")
    }

    public func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action) {
        print("Selected : \(action)")
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

// MARK: - RemoteImageViewDataSource

extension FrontpageViewDemoView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        loadImage(imagePath: imagePath, completion: completion)
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontpageViewDemoView: FrontPageSavedSearchesViewDelegate {
    public func frontPageSavedSearchesView(_ view: FrontPageSavedSearchesView, didSelectSavedSearch savedSearch: FrontPageSavedSearchViewModel) {
        print("Did select saved search with title", savedSearch.title)
    }

    public func frontPageSavedSearchesViewDidSelectActionButton(_ view: FrontPageSavedSearchesView) {
        print("Did select action button")
    }
}

// MARK: - FrontPageTransactionFeedDelegate

extension FrontpageViewDemoView: FrontPageTransactionViewDelegate {
    public func transactionViewTapped(_ transactionView: FrontPageTransactionView) {
        print("TransactionFeedView tapped: \(transactionView.viewModel?.id ?? "")")
    }
}
