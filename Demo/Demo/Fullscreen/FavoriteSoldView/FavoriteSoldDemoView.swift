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
                                    adsGridViewDelegate: self,
                                    adsGridViewDataSource: self,
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

extension FavoriteSoldDemoView: AdsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.favoriteSoldView.reloadAds()
            })
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}
    public func adsGridViewDidStartRefreshing(_ adsGridView: AdsGridView) {}

    public func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdsGridViewCell, at index: Int) {
        adsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdsGridViewDataSource

extension FavoriteSoldDemoView: AdsGridViewDataSource {
    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    public func adsGridView(_ adsGridView: AdsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [AdsGridViewCell.self]
    }

    public func adsGridView(_ adsGridView: AdsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = ads[indexPath.item]
        return AdsGridViewCell.height(for: model, width: width)
    }

    public func adsGridView(_ adsGridView: AdsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = ads[indexPath.item]

        let cell = collectionView.dequeue(AdsGridViewCell.self, for: indexPath)
        cell.dataSource = adsGridView
        cell.delegate = adsGridView
        cell.configure(with: model, atIndex: indexPath.item)
        return cell
    }

    public func adsGridView(_ adsGridView: AdsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        return loadImageWithPath(imagePath, imageWidth: imageWidth, completion: completion)
    }

    public func adsGridView(_ adsGridView: AdsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
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
