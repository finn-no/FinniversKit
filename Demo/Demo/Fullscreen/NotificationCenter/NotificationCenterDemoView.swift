//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit
import FinnUI

final class NotificationCenterDemoView: UIView {

    private lazy var segments = [
        personalSegment,
        savedSearchSegment
    ]

    private lazy var notificationsCenterView: NotificationCenterView = {
        let notificationCenterView = NotificationCenterView(withAutoLayout: true)
        notificationCenterView.selectedSegment = 1
        notificationCenterView.dataSource = self
        notificationCenterView.delegate = self
        notificationCenterView.remoteImageViewDataSource = self
        return notificationCenterView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notificationsCenterView)
        notificationsCenterView.fillInSuperview()
        notificationsCenterView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension NotificationCenterDemoView: NotificationCenterViewDataSource {
    func numberOfSegments(in view: NotificationCenterView) -> Int {
        segments.count
    }

    func notificationCenterView(_ view: NotificationCenterView, titleInSegment segment: Int) -> String {
        segments[segment].title
    }

    func notificationCenterView(_ view: NotificationCenterView, numberOfSectionsInSegment segment: Int) -> Int {
        segments[segment].sections.count
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, numberOfRowsInSection section: Int) -> Int {
        segments[segment].sections[section].items.count
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForCellAt indexPath: IndexPath) -> NotificationCenterCellType {
        segments[segment].sections[indexPath.section].items[indexPath.row]
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, timestampForCellAt indexPath: IndexPath) -> String? {
        "3 min siden"
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, modelForHeaderInSection section: Int) -> NotificationCenterHeaderViewModel {
        segments[segment].sections[section]
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, overflowInSection section: Int) -> Bool {
        guard let count = segments[segment].sections[section].count else { return false }
        return count > segments[segment].sections[section].items.count
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, titleForFooterInSection section: Int) -> String {
        "Vis flere treff"
    }
}

extension NotificationCenterDemoView: NotificationCenterViewDelegate {
    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectModelAt indexPath: IndexPath) {
        let cellType = segments[segment].sections[indexPath.section].items[indexPath.row]

        switch cellType {
        case let .notificationCell(model):
            if var item = model as? NotificationCenterItem {
                item.isRead = true
                segments[segment].sections[indexPath.section].items[indexPath.row] = .notificationCell(item)
                view.reloadRows(at: [indexPath], inSegment: segment)
            }
        default:
            break
        }
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectSavedSearchButtonIn section: Int) {
        print("Saved search button selected")
    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didSelectFooterButtonInSection section: Int) {

    }

    func notificationCenterView(_ view: NotificationCenterView, segment: Int, didPullToRefreshUsing refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            refreshControl.endRefreshing()
        }
    }
}

extension NotificationCenterDemoView: FeedbackViewDelegate {
    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forState state: FeedbackView.State) {
        print("Did select button type: \(buttonType)")
    }
}

extension NotificationCenterDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
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

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {

    }
}
