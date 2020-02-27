//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct NotificationModel: NotificationCenterCellModel {
    let imagePath: String?
    let title: String
    let priceText: String? = "3000 kr"
    var read: Bool
    let ribbonViewModel: RibbonViewModel?
}

private struct Section: NotificationCenterSectionHeaderViewModel {
    let title: String?
    let details: NotificationCenterSectionDetails?
    var items: [NotificationModel]
}

class NotificationCenterDemoView: UIView {

    private var data = [
        Section(
            title: "I dag",
            details: .link(text: "2 nye treff:", title: "Hus som jeg må kjøpe før jeg fyller 40 år", showSearchIcon: true),
            items: [
            NotificationModel(
                imagePath: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
                title: "Dette er en tittel",
                read: false,
                ribbonViewModel: RibbonViewModel(style: .warning, title: "Solgt")),
            NotificationModel(
                imagePath: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
                title: "Dette er også en tittel",
                read: false,
                ribbonViewModel: nil),
        ]),
        Section(
            title: "Tidligere",
            details: .link(text: "3 nye treff:", title: "Husstander", showSearchIcon: true),
            items: [
            NotificationModel(
                imagePath: nil,
                title: "Dette er en tittel som er veeeeeldig lang",
                read: true,
                ribbonViewModel: RibbonViewModel(style: .success, title: "Ny pris")),
            NotificationModel(
                imagePath: "http://jonvilma.com/images/house-6.jpg",
                title: "Tittel",
                read: false,
                ribbonViewModel: RibbonViewModel(style: .disabled, title: "Inaktiv")),
            NotificationModel(
                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                title: "Dette er en tittel",
                read: true,
                ribbonViewModel: nil),
        ]),
        Section(
            title: nil,
            details: .static(text: "2 nye treff:", value: "Andre husstander"),
            items: [
            NotificationModel(
                imagePath: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
                title: "Dette er en tittel",
                read: true,
                ribbonViewModel: nil),
            NotificationModel(
                imagePath: "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg",
                title: "Dette er en tittel",
                read: true,
                ribbonViewModel: nil)
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

    func notificationCenterView(_ view: NotificationCenterView, modelForSection section: Int) -> NotificationCenterSectionHeaderViewModel {
        data[section]
    }

    func notificationCenterView(_ view: NotificationCenterView, modelForRowAt indexPath: IndexPath) -> NotificationCenterCellModel {
        data[indexPath.section].items[indexPath.row]
    }

    func notificationCenterView(_ view: NotificationCenterView, timestampForModelAt indexPath: IndexPath) -> String? {
        "15 minutter siden"
    }
}

extension NotificationCenterDemoView: NotificationCenterViewDelegate {
    func notificationCenterView(_ view: NotificationCenterView, didSelectModelAt indexPath: IndexPath) {
        data[indexPath.section].items[indexPath.row].read = true
        notificationCenterView.reloadRows(at: [indexPath])
    }

    func notificationCenterView(_ view: NotificationCenterView, didSelectNotificationDetailsIn section: Int) {
        print("Did select saved search at: \(section)")
    }

    func notificationCenterView(_ view: NotificationCenterView, didPullToRefreshWith refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.reloadData()
            refreshControl.endRefreshing()
        }
    }

    func notificationCenterViewWillReachEndOfContent(_ view: NotificationCenterView) {
        print("Will reach end of content")
    }

    func notificationCenterView(_ view: NotificationCenterView, didReachEndOfContentWith activityIndicatorView: UIActivityIndicatorView) {
        print("Did reach end of content")
        activityIndicatorView.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            activityIndicatorView.stopAnimating()
        }
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
