//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct NotificationModel: NotificationCenterCellModel {
    let imagePath: String? = ""
    let title: String = "Sofa"
    let price: String = "300 kr"
    let timestamp: String = "15 min siden"
    var read: Bool
    let statusTitle: String?
    let statusStyle: RibbonView.Style?
    let savedSearchText: String = "Treff i lagret søk"
    let savedSearchTitle: String = ""
}

private struct Section {
    let title: String
    var items: [NotificationModel]
}

class NotificationCenterDemoView: UIView {

    private var data = [
        Section(title: "I dag", items: [
            NotificationModel(read: false, statusTitle: "Solgt", statusStyle: .warning),
            NotificationModel(read: false, statusTitle: nil, statusStyle: nil),
        ]),
        Section(title: "Tidligere", items: [
            NotificationModel(read: true, statusTitle: "Solgt", statusStyle: .warning),
            NotificationModel(read: false, statusTitle: "Inaktiv", statusStyle: .disabled),
            NotificationModel(read: true, statusTitle: nil, statusStyle: nil),
            NotificationModel(read: true, statusTitle: nil, statusStyle: nil),
            NotificationModel(read: true, statusTitle: nil, statusStyle: nil)
        ])
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
        data.count
    }

    func notificationCenterView(_ view: NotificationCenterView, numberOfRowsIn section: Int) -> Int {
        data[section].items.count
    }

    func notificationCenterView(_ view: NotificationCenterView, modelForRowAt indexPath: IndexPath) -> NotificationCenterCellModel {
        data[indexPath.section].items[indexPath.row]
    }
}

extension NotificationCenterDemoView: NotificationCenterViewDelegate {
    func notificationCenterView(_ view: NotificationCenterView, didSelectModelAt indexPath: IndexPath) {
        data[indexPath.section].items[indexPath.row].read = true
        notificationCenterView.reloadRows(at: [indexPath])
    }

    func notificationCenterView(_ view: NotificationCenterView, titleForSection section: Int) -> String {
        data[section].title
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
