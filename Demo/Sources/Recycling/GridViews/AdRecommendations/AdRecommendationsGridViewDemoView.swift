//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

/// For use with AdRecommendationsGridView.
struct AdDataSource {
    let models: [AdRecommendation] = {
        var ads: [AdRecommendation] = AdFactory.create(numberOfModels: 11).map { .ad($0) }
        ads.insert(contentsOf: JobAdFactory.create(numberOfModels: 2).map { .job($0) }, at: 1)
        ads.insert(.ad(AdFactory.googleDemoAd), at: 4)
        ads.insert(.ad(AdFactory.nativeDemoAd), at: 8)
        var externals: [AdRecommendation] = ExternalAdFactory.create(numberOfModels: 4)
            .map { .external($0) }
        ads.insert(externals[0], at: 0)
        ads.append(contentsOf: externals.dropFirst())
        return ads
    }()
}

class AdRecommendationsGridViewDemoView: UIView {

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

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(adRecommendationsGridView)
        adRecommendationsGridView.fillInSuperview()
    }
}

extension AdRecommendationsGridViewDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case fullWidth
        case twoColumns
        case threeColumns
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .fullWidth:
            numberOfColumns = .fullWidth
        case .twoColumns:
            numberOfColumns = .columns(2)
        case .threeColumns:
            numberOfColumns = .columns(3)
        }
    }
}

extension AdRecommendationsGridViewDemoView: AdRecommendationsGridViewDelegate {
    func adRecommendationsGridViewDidStartRefreshing(_ adRecommendationsGridView: AdRecommendationsGridView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak adRecommendationsGridView] in
            adRecommendationsGridView?.reloadData()
        }
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {}

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adRecommendationsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

extension AdRecommendationsGridViewDemoView: AdRecommendationsGridViewDataSource {
    func numberOfColumns(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        numberOfColumns
    }

    func numberOfItems(inAdRecommendationsGridView adRecommendationsGridView: AdRecommendationsGridView) -> Int {
        return dataSource.models.count
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            StandardAdRecommendationCell.self,
            JobAdRecommendationCell.self,
            BannerAdDemoCell.self,
            NativeAdvertRecommendationDemoCell.self,
            ExternalAdRecommendationCell.self
        ]
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
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
        case .external(let ad):
            return ExternalAdRecommendationCell.height(for: ad, width: width)
        case .job(let ad):
            return JobAdRecommendationCell.height(for: ad, width: width)
        }
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                return cell
            }
        case .job(let ad):
            let cell = collectionView.dequeue(JobAdRecommendationCell.self, for: indexPath)
            cell.imageDataSource = adRecommendationsGridView
            cell.delegate = adRecommendationsGridView
            cell.configure(with: ad, atIndex: indexPath.item)
            return cell
        case .external(let ad):
            let cell = collectionView.dequeue(ExternalAdRecommendationCell.self, for: indexPath)
            cell.imageDataSource = adRecommendationsGridView
            cell.delegate = adRecommendationsGridView
            cell.configure(with: ad, atIndex: indexPath.item)
            return cell
        }
    }

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    func adRecommendationsGridView(_ adRecommendationsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
