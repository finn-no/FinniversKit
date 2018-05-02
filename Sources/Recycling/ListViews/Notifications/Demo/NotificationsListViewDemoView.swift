//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

/// For use with NotificationsListView.
public class NotificationDataSource: NSObject {
    let groups = NotificationFactory.create(numberOfGroups: 9)
}

public class NotificationsListViewDemoView: UIView {
    lazy var dataSource: NotificationDataSource = {
        return NotificationDataSource()
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
    public func notificationsListView(_ notificationsListView: NotificationsListView, didSelectItemAtIndexPath indexPath: IndexPath) {}

    public func notificationsListView(_ notificationsListView: NotificationsListView, willDisplayItemAtIndexPath indexPath: IndexPath) {}

    public func notificationsListView(_ notificationsListView: NotificationsListView, didScrollInScrollView scrollView: UIScrollView) {}

    public func notificationsListView(_ notificationsListView: NotificationsListView, titleForHeaderInSection section: Int) -> String? {
        let group = dataSource.groups[section]
        return group.title
    }

    public func notificationsListView(_ notificationsListView: NotificationsListView, titleForFooterInSection section: Int) -> String? {
        let group = dataSource.groups[section]
        return String(describing: group.totalNumberOfElements)
    }

    public func notificationsListView(_ notificationsListView: NotificationsListView, didSelectHeaderAtSection section: Int) {}

    public func notificationsListView(_ notificationsListView: NotificationsListView, didSelectFooterAtSection section: Int) {}
}

extension NotificationsListViewDemoView: NotificationsListViewDataSource {
    public func numberOfSections(inNotificationsListView notificationsListView: NotificationsListView) -> Int {
        return dataSource.groups.count
    }

    public func notificationsListView(_ notificationsListView: NotificationsListView, numberOfItemsInSection section: Int) -> Int {
        let group = dataSource.groups[section]
        return group.notifications.count
    }

    public func notificationsListView(_ notificationsListView: NotificationsListView, modelAtIndexPath indexPath: IndexPath) -> NotificationsListViewModel {
        let group = dataSource.groups[indexPath.section]
        let notification = group.notifications[indexPath.row]
        return notification
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
