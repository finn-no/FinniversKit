//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class FavoriteSoldDemoView: UIView, Demoable {

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

    override func layoutSubviews() {
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
    func favoriteSoldViewDidTapRetryButton(_ favoriteSoldView: FavoriteSoldView) {}

    func favoriteSoldViewDidTapSoldFavorite(_ favoriteSoldView: FavoriteSoldView) {}
}

extension FavoriteSoldDemoView: AdRecommendationsGridViewDelegate {
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.favoriteSoldView.reloadAds()
            })
        }
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}
    func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {}

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adRecommendationsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdRecommendationsGridViewDataSource

extension FavoriteSoldDemoView: AdRecommendationsGridViewDataSource {
    func numberOfColumns(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        return nil
    }

    func numberOfItems(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [StandardAdRecommendationCell.self]
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = ads[indexPath.item]
        return StandardAdRecommendationCell.height(for: model, width: width)
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = ads[indexPath.item]

        let cell = collectionView.dequeue(StandardAdRecommendationCell.self, for: indexPath)
        cell.imageDataSource = adRecommendationsGridView
        cell.delegate = adRecommendationsGridView
        cell.configure(with: model, atIndex: indexPath.item)
        return cell
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        return loadImageWithPath(imagePath, imageWidth: imageWidth, completion: completion)
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - RemoteImageViewDataSource

extension FavoriteSoldDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        return loadImageWithPath(imagePath, imageWidth: imageWidth, completion: completion)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

private struct FavoriteSoldDefaultData: FavoriteSoldViewModel {
    let title: String? = "Ubrukt ByTiMo skjørt"
    let bodyText = "Din favoritt er solgt, men vi har flere annonser vi tror du vil like."
    let ribbonTitle = "Solgt"
    let similarAdsTitle = "Lignende annonser"
    let imageUrl: String? = "https://images.finncdn.no/dynamic/default/2020/4/vertical-0/24/1/176/773/561_868051191.jpg"
    let retryButtonTitle = ""
    let noRecommendationsTitle = ""
}
