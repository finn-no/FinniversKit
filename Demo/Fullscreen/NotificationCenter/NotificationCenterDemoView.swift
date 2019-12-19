//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct NotificationModel: NotificationCenterCellModel {
    let imagePath: String?
    let title: String
    let subtitle: String
    let price: String
    let date: String
    var read: Bool
    weak var imageSource: NotificationCenterCellImageSource?
}

class NotificationCenterDemoView: UIView {

    private lazy var data = [
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: false, imageSource: self),
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: false, imageSource: self),
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: true, imageSource: self),
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: false, imageSource: self),
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: true, imageSource: self),
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: true, imageSource: self),
        NotificationModel(imagePath: nil, title: "Sofa", subtitle: "Komfortabel sofa selges billig", price: "Kr 500", date: "15 min siden", read: true, imageSource: self)
    ]

    private lazy var notificationCenterView: NotificationCenterView = {
        let view = NotificationCenterView(withAutoLayout: true)
        view.dataSource = self
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

extension NotificationCenterDemoView: NotificationCenterCellImageSource {
    func notificationCenterCell(_ cell: NotificationCenterCell, loadImageAt path: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        completion(.success(nil))
        print("Load image")
    }
}
