//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// For use with AdRecommendationsGridView.
public struct AdDataSource {
    let models: [AdRecommendation] = {
        var ads: [AdRecommendation] = AdFactory.create(numberOfModels: 11).map { .ad($0) }
        ads.insert(contentsOf: JobAdFactory.create(numberOfModels: 2).map { .job($0) }, at: 1)
        ads.insert(.ad(AdFactory.googleDemoAd), at: 4)
        ads.insert(.ad(AdFactory.nativeDemoAd), at: 8)
        return ads
    }()
}

public class AdRecommendationsGridViewDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Full width", action: { self.numberOfColumns = .fullWidth }),
        TweakingOption(title: "Two columns", action: { self.numberOfColumns = .columns(2) }),
        TweakingOption(title: "Three columns", action: { self.numberOfColumns = .columns(3) })
    ]

    private var numberOfColumns: AdRecommendationsGridView.ColumnConfiguration = .columns(2) {
        didSet {
            adRecommendationsGridView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private lazy var dataSource: AdDataSource = AdDataSource()

    private lazy var adRecommendationsGridView: AdRecommendationsGridView = {
        let view = AdRecommendationsGridView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(adRecommendationsGridView)
        adRecommendationsGridView.fillInSuperview()
    }
}

extension AdRecommendationsGridViewDemoView: AdRecommendationsGridViewDelegate {
    public func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak adRecommendationsGridView] in
            adRecommendationsGridView?.reloadData()
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {}

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adRecommendationsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

extension AdRecommendationsGridViewDemoView: AdRecommendationsGridViewDataSource {
    public func numberOfColumns(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        numberOfColumns
    }

    public func numberOfItems(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> Int {
        return dataSource.models.count
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            StandardAdRecommendationCell.self,
            JobAdRecommendationCell.self,
            BannerAdDemoCell.self,
            NativeAdvertRecommendationDemoCell.self,
        ]
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = dataSource.models[indexPath.item]

        switch model {
        case .ad(let ad):
            switch ad.adType {
            case .native:
                return NativeAdvertRecommendationDemoCell.height(for: width)
            case .google:
                return 300
            default:
                return StandardAdRecommendationCell.height(for: ad, width: width)
            }
        case .job(let ad):
            return JobAdRecommendationCell.height(for: ad, width: width)
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource.models[indexPath.item]

        switch model {
        case .ad(let ad):
            switch ad.adType {
            case .native:
                return collectionView.dequeue(NativeAdvertRecommendationDemoCell.self, for: indexPath)
            case .google:
                return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)
            default:
                let cell = collectionView.dequeue(StandardAdRecommendationCell.self, for: indexPath)
                cell.imageDataSource = adRecommendationsGridView
                cell.delegate = adRecommendationsGridView
                cell.configure(with: ad, atIndex: indexPath.item)
                //cell.showImageDescriptionView = ad.scaleImageToFillView
                return cell
            }
        case .job(let ad):
            let cell = collectionView.dequeue(JobAdRecommendationCell.self, for: indexPath)
            cell.imageDataSource = adRecommendationsGridView
            cell.delegate = adRecommendationsGridView
            cell.configure(with: ad, atIndex: indexPath.item)
            return cell
        }
    }

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

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

    public func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
