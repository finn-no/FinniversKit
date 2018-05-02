//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

/// For use with NotificationsListView.
public class GridPreviewDataSource: NSObject {
    let models = GridPreviewFactory.create(numberOfModels: 9)
}

public class NotificationsListViewDemoView: UIView {
    lazy var dataSource: GridPreviewDataSource = {
        return GridPreviewDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = NotificationsListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension NotificationsListViewDemoView: NotificationsListViewDelegate {
    public func notificationsListView(_ notificationsListView: NotificationsListView, didSelectItemAtIndex index: Int) {}

    public func notificationsListView(_ notificationsListView: NotificationsListView, willDisplayItemAtIndex index: Int) {}

    public func notificationsListView(_ notificationsListView: NotificationsListView, didScrollInScrollView scrollView: UIScrollView) {}
}

extension NotificationsListViewDemoView: NotificationsListViewDataSource {
    public func numberOfItems(inNotificationsListView notificationsListView: NotificationsListView) -> Int {
        return dataSource.models.count
    }

    public func notificationsListView(_ notificationsListView: NotificationsListView, modelAtIndex index: Int) -> NotificationsListViewModel {
        return dataSource.models[index]
    }

    public func notificationsListView(_ notificationsListView: NotificationsListView, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    public func notificationsListView(_ notificationsListView: NotificationsListView, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat) {}
}
