//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// For use with AdsGridView.
public class AdDataSource: NSObject {
    let models: [Ad] = {
        var ads = AdFactory.create(numberOfModels: 9)
        ads.insert(AdFactory.googleDemoAd, at: 4)
        return ads
    }()
}

public class AdsGridViewDemoView: UIView {
    lazy var dataSource: AdDataSource = {
        return AdDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = AdsGridView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
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

    public func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdsGridViewCell, at index: Int) {}
}

extension AdsGridViewDemoView: AdsGridViewDataSource {
    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return dataSource.models.count
    }

    public func adsGridView(_ adsGridView: AdsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            AdsGridViewCell.self,
            BannerAdDemoCell.self
        ]
    }

    public func adsGridView(_ adsGridView: AdsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = dataSource.models[indexPath.item]

        switch model.adType {
        case .google:
            return 300
        default:
            return AdsGridViewCell.height(
                for: model,
                width: width
            )
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource.models[indexPath.item]

        switch model.adType {
        case .google:
            return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)

        default:
            let cell = collectionView.dequeue(AdsGridViewCell.self, for: indexPath)
            cell.dataSource = adsGridView
            cell.delegate = adsGridView
            cell.configure(with: model, atIndex: indexPath.item)
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
