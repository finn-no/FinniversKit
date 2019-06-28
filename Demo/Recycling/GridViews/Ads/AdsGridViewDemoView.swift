//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// For use with AdsGridView.
public class AdDataSource: NSObject {
    let models = AdFactory.create(numberOfModels: 9)
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

    public func adsGridView(_ adsGridView: AdsGridView, modelAtIndex index: Int) -> AdsGridViewModel? {
        return dataSource.models[safe: index]
    }

    public func adsGridView(_ adsGridView: AdsGridView, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((AdsGridViewModel, UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
            completion(model, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(model, image)
                } else {
                    completion(model, nil)
                }
            }
        }

        task.resume()
    }

    public func adsGridView(_ adsGridView: AdsGridView, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat) {}
}
