//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FavoriteSoldDemoView: UIView {

    private let ads: [Ad] = AdFactory.create(numberOfModels: 60)
    private var visibleItems = 20
    private var didSetupView = false

    private lazy var favoriteSoldView: FavoriteSoldView = {
        let view = FavoriteSoldView(favoriteSoldViewDelegate: self,
                                    adRecommendationsGridViewDelegate: self,
                                    adRecommendationsGridViewDataSource: self,
                                    remoteImageViewDataSource: self)
        view.configure(with: FavoriteSoldDefaultData())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        }
    }

    private func setup() {
        addSubview(favoriteSoldView)
        favoriteSoldView.fillInSuperview()
        favoriteSoldView.reloadAds()
    }

    private func loadImageWithPath(_ imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

extension FavoriteSoldDemoView: FavoriteSoldViewDelegate {
    public func favoriteSoldViewDidTapRetryButton(_ favoriteSoldView: FavoriteSoldView) {}

    public func favoriteSoldViewDidTapSoldFavorite(_ favoriteSoldView: FavoriteSoldView) {}
}

extension FavoriteSoldDemoView: AdRecommendationsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.favoriteSoldView.reloadAds()
            })
        }
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}
    public func adsGridViewDidStartRefreshing(_ adsGridView: AdRecommendationsGridView) {}

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdRecommendationsGridViewDataSource

extension FavoriteSoldDemoView: AdRecommendationsGridViewDataSource {
    public func numberOfColumns(inAdsGridView adsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        return nil
    }

    public func numberOfItems(inAdsGridView adsGridView: AdRecommendationsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [StandardAdRecommendationCell.self]
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = ads[indexPath.item]
        return StandardAdRecommendationCell.height(for: model, width: width)
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = ads[indexPath.item]

        let cell = collectionView.dequeue(StandardAdRecommendationCell.self, for: indexPath)
        cell.imageDataSource = adsGridView
        cell.delegate = adsGridView
        cell.configure(with: model, atIndex: indexPath.item)
        return cell
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        return loadImageWithPath(imagePath, imageWidth: imageWidth, completion: completion)
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - RemoteImageViewDataSource

extension FavoriteSoldDemoView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    public func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        return loadImageWithPath(imagePath, imageWidth: imageWidth, completion: completion)
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

private struct FavoriteSoldDefaultData: FavoriteSoldViewModel {
    public let title: String? = "Ubrukt ByTiMo skjørt"
    public let bodyText = "Din favoritt er solgt, men vi har flere annonser vi tror du vil like."
    public let ribbonTitle = "Solgt"
    public let similarAdsTitle = "Lignende annonser"
    public let imageUrl: String? = "https://images.finncdn.no/dynamic/default/2020/4/vertical-0/24/1/176/773/561_868051191.jpg"
    public let retryButtonTitle = ""
    public let noRecommendationsTitle = ""
}
