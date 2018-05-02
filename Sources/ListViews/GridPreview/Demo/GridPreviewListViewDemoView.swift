//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

/// For use with GridPreviewListView.
public class GridPreviewDataSource: NSObject {
    let models = GridPreviewFactory.create(numberOfModels: 9)
}

public class GridPreviewListViewDemoView: UIView {
    lazy var dataSource: GridPreviewDataSource = {
        return GridPreviewDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = GridPreviewListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension GridPreviewListViewDemoView: GridPreviewListViewDelegate {
    public func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, didSelectItemAtIndex index: Int) {}

    public func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, willDisplayItemAtIndex index: Int) {}

    public func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, didScrollInScrollView scrollView: UIScrollView) {}
}

extension GridPreviewListViewDemoView: GridPreviewListViewDataSource {
    public func numberOfItems(inGridPreviewListView gridPreviewListView: GridPreviewListView) -> Int {
        return dataSource.models.count
    }

    public func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, modelAtIndex index: Int) -> GridPreviewListViewModel {
        return dataSource.models[index]
    }

    public func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, loadImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let path = model.imagePath, let url = URL(string: path) else {
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

    public func gridPreviewListView(_ gridPreviewListView: GridPreviewListView, cancelLoadingImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat) {}
}
