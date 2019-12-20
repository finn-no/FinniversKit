//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct NotificationModel: NotificationCenterCellModel {
    let imagePath: String?
    let title: String
    let date: String
    var read: Bool
}

class NotificationCenterDemoView: UIView {

    private lazy var data = [
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: false),
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: false),
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: true),
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: false),
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: true),
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: true),
        NotificationModel(imagePath: nil, title: "Sofa", date: "15 min siden", read: true)
    ]

    private lazy var notificationCenterView: NotificationCenterView = {
        let view = NotificationCenterView(withAutoLayout: true)
        view.delegate = self
        view.dataSource = self
        view.imageViewDataSource = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(notificationCenterView)
        notificationCenterView.fillInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCenterDemoView: NotificationCenterViewDataSource {
    func numberOfSections(in view: NotificationCenterView) -> Int {
        1
    }

    func notificationCenterView(_ view: NotificationCenterView, numberOfRowsIn section: Int) -> Int {
        data.count
    }

    func notificationCenterView(_ view: NotificationCenterView, modelForRowAt indexPath: IndexPath) -> NotificationCenterCellModel {
        data[indexPath.row]
    }
}

extension NotificationCenterDemoView: NotificationCenterViewDelegate {
    func notificationCenterView(_ view: NotificationCenterView, didSelectModelAt indexPath: IndexPath) {
        data[indexPath.row].read = true
        notificationCenterView.reloadRows(at: [indexPath])
    }
}

extension NotificationCenterDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        completion(nil)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {

    }
}
