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

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension GridPreviewListViewDemoView: GridPreviewListViewDelegate {
    public func didSelect(itemAtIndex index: Int, inGridPreviewListView gridView: GridPreviewListView) {
        // Not in use
    }

    public func willDisplay(itemAtIndex index: Int, inGridPreviewListView gridView: GridPreviewListView) {
        // Don't care
    }

    public func didScroll(gridScrollView: UIScrollView) {
        // Don't care
    }
}

extension GridPreviewListViewDemoView: GridPreviewListViewDataSource {
    public func numberOfItems(inGridPreviewListView previewGridView: GridPreviewListView) -> Int {
        return dataSource.models.count
    }

    public func previewGridView(_ previewGridView: GridPreviewListView, modelAtIndex index: Int) -> GridPreviewListViewModel {
        return dataSource.models[index]
    }

    public func loadImage(for model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    public func cancelLoadImage(for model: GridPreviewListViewModel, imageWidth: CGFloat) {
        // No point in doing this in demo
    }
}
