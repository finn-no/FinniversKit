//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// For use with AdsGridView.
public struct AdDataSource {
    let models: [AdRecommendation] = {
        var ads: [AdRecommendation] = AdFactory.create(numberOfModels: 9).map { .ad($0) }
        ads.insert(contentsOf: JobAdFactory.create(numberOfModels: 2).map { .job($0) }, at: 1)
        ads.insert(.ad(AdFactory.googleDemoAd), at: 4)
        ads.insert(.ad(AdFactory.nativeDemoAd), at: 8)
        return ads
    }()
}

public class AdsGridViewDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Full width", action: { self.numberOfColumns = .fullWidth }),
        TweakingOption(title: "Two columns", action: { self.numberOfColumns = .columns(2) }),
        TweakingOption(title: "Three columns", action: { self.numberOfColumns = .columns(3) })
    ]

    private var numberOfColumns: AdsGridView.ColumnConfiguration = .columns(2) {
        didSet {
            adsGridView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private lazy var dataSource: AdDataSource = AdDataSource()

    private lazy var adsGridView: AdsGridView = {
        let view = AdsGridView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(adsGridView)
        adsGridView.fillInSuperview()
    }
}

extension AdsGridViewDemoView: AdsGridViewDelegate {
    public func adsGridViewDidStartRefreshing(_ adsGridView: AdsGridView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak adsGridView] in
            adsGridView?.reloadData()
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}

    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {}

    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}

    public func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

extension AdsGridViewDemoView: AdsGridViewDataSource {
    public func numberOfColumns(inAdsGridView adsGridView: AdsGridView) -> AdsGridView.ColumnConfiguration? {
        numberOfColumns
    }

    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return dataSource.models.count
    }

    public func adsGridView(_ adsGridView: AdsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            AdsGridViewCell.self,
            JobRecommendationCell.self,
            BannerAdDemoCell.self,
            NativeAdvertRecommendationDemoCell.self,
        ]
    }

    public func adsGridView(_ adsGridView: AdsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = dataSource.models[indexPath.item]

        switch model {
        case .ad(let ad):
            switch ad.adType {
            case .native:
                return NativeAdvertRecommendationDemoCell.height(for: width)
            case .google:
                return 300
            default:
                return AdsGridViewCell.height(for: ad, width: width)
            }
        case .job(let ad):
            return JobRecommendationCell.height(for: ad, width: width)
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource.models[indexPath.item]

        switch model {
        case .ad(let ad):
            switch ad.adType {
            case .native:
                return collectionView.dequeue(NativeAdvertRecommendationDemoCell.self, for: indexPath)
            case .google:
                return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)
            default:
                let cell = collectionView.dequeue(AdsGridViewCell.self, for: indexPath)
                cell.imageDataSource = adsGridView
                cell.delegate = adsGridView
                cell.configure(with: ad, atIndex: indexPath.item)
                cell.showImageDescriptionView = ad.scaleImageToFillView
                return cell
            }
        case .job(let ad):
            let cell = collectionView.dequeue(JobRecommendationCell.self, for: indexPath)
            cell.imageDataSource = adsGridView
            cell.delegate = adsGridView
            cell.configure(with: ad, atIndex: indexPath.item)
            return cell
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    public func adsGridView(_ adsGridView: AdsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
