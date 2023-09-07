//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

/// For use with NotificationsListView.
class NotificationDataSource: NSObject {
    let groups = NotificationFactory.create(numberOfGroups: 3)
}

class NotificationsListViewDemoView: UIView, Demoable {
    lazy var dataSource: NotificationDataSource = {
        return NotificationDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = NotificationsListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension NotificationsListViewDemoView: NotificationsListViewDelegate {
    func notificationsListView(_ notificationsListView: NotificationsListView, didSelectItemAtIndexPath indexPath: IndexPath) {}

    func notificationsListView(_ notificationsListView: NotificationsListView, willDisplayItemAtIndexPath indexPath: IndexPath) {}

    func notificationsListView(_ notificationsListView: NotificationsListView, didScrollInScrollView scrollView: UIScrollView) {}

    func notificationsListView(_ notificationsListView: NotificationsListView, didSelectHeaderAtSection section: Int) {}

    func notificationsListView(_ notificationsListView: NotificationsListView, didSelectFooterAtSection section: Int) {}
}

extension NotificationsListViewDemoView: NotificationsListViewDataSource {
    func numberOfSections(inNotificationsListView notificationsListView: NotificationsListView) -> Int {
        return dataSource.groups.count
    }

    func notificationsListView(_ notificationsListView: NotificationsListView, numberOfItemsInSection section: Int) -> Int {
        let group = dataSource.groups[section]
        return group.notifications.count
    }

    func notificationsListView(_ notificationsListView: NotificationsListView, groupModelAtSection section: Int) -> NotificationsGroupListViewModel {
        return dataSource.groups[section]
    }

    func notificationsListView(_ notificationsListView: NotificationsListView, modelAtIndexPath indexPath: IndexPath) -> NotificationsListViewModel {
        let group = dataSource.groups[indexPath.section]
        let notification = group.notifications[indexPath.row]
        return notification
    }

    func notificationsListView(_ notificationsListView: NotificationsListView, loadImageForModel model: NotificationsListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    func notificationsListView(_ notificationsListView: NotificationsListView, cancelLoadingImageForModel model: NotificationsListViewModel, imageWidth: CGFloat) {}
}
