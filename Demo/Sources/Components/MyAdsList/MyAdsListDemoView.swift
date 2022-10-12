import UIKit
import FinniversKit

class MyAdsListDemoView: UIView {

    // MARK: - Private properties

    private var demoAds = Array.demoAds

    private lazy var myAdsListView: MyAdsListView = {
        let view = MyAdsListView(remoteImageViewDataSource: self, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        myAdsListView.configure(with: demoAds)
        addSubview(myAdsListView)
        myAdsListView.fillInSuperview()
    }
}

// MARK: - MyAdsListViewDelegate

extension MyAdsListDemoView: MyAdsListViewDelegate {
    func myAdsListView(_ view: MyAdsListView, didSelectAdAt indexPath: IndexPath) {
        print("👉 Did select ad at index \(indexPath.row)")
    }
}

extension MyAdsListDemoView: NavigationControllerContainable {
    var rightBarButtonItems: [UIBarButtonItem] {
        if #available(iOS 14.0, *) {
            return [
                UIBarButtonItem(
                    title: "Reset",
                    primaryAction: UIAction(handler: { [weak self] _ in
                        self?.resetAds()
                    })
                ),
                UIBarButtonItem(
                    title: "Shift list",
                    primaryAction: UIAction(handler: { [weak self] _ in
                        self?.shiftAds()
                    })
                ),
                UIBarButtonItem(
                    title: "Reverse list",
                    primaryAction: UIAction(handler: { [weak self] _ in
                        self?.reverseAds()
                    })
                ),

            ]
        } else {
            return []
        }
    }

    private func resetAds() {
        demoAds = .demoAds
        myAdsListView.configure(with: demoAds)
    }

    private func shiftAds() {
        demoAds.shiftRight()
        myAdsListView.configure(with: demoAds)
    }

    private func reverseAds() {
        demoAds = demoAds.reversed()
        myAdsListView.configure(with: demoAds)
    }
}

// MARK: - RemoteImageTableViewCellDataSource

extension MyAdsListDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
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

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - Private extensions

private extension Array where Element == MyAdModel {
    mutating func shiftRight() {
        if let lastAd = popLast() {
            insert(lastAd, at: 0)
        }
    }

    static var demoAds: [MyAdModel] {
        (0..<15).map {
            MyAdModel(
                adId: "\($0)",
                title: title(index: $0),
                subtitle: subtitle(index: $0),
                imageUrl: imageUrl(index: $0),
                expires: expires(index: $0),
                numFavorites: numFavorites(index: $0),
                numViews: numViews(index: $0),
                ribbon: ribbon(index: $0)
            )
        }
    }


    static func title(index: Int) -> String {
        randomElement(index: index, from: [
            "Black & Decker Multisliper 220w",
            "Geniale skioppheng for langrennski",
            "Perfect Click Ultimate Superb Wonderful fliser, nye og/eller pent brukte ønskes kjøpt billig (eller dyrt) snarest mulig"
        ])
    }

    static func subtitle(index: Int) -> String? {
        randomElement(index: index, from: [
            "Torget · 100 kr",
            "Torget · Ønskes kjøpt",
            "Bolig til leie · 12 000 000 000 kr/mnd",
            nil
        ])
    }

    static func imageUrl(index: Int) -> String? {
        randomElement(index: index, from: [
            "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
            "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
            "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
            "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
            "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
            nil
        ])
    }

    static func expires(index: Int) -> String? {
        randomElement(index: index, from: [
            "50 dager igjen",
            "3200 dager igjen",
            "En fantasillion dager igjen",
            nil
        ])
    }

    static func numFavorites(index: Int) -> String {
        randomElement(index: index, from: [
            "0",
            "120",
            "3456",
            "18 000"
        ])
    }

    static func numViews(index: Int) -> String {
        randomElement(index: index, from: [
            "5 000",
            "8",
            "9 876",
            "970 000"
        ])
    }

    static func ribbon(index: Int) -> RibbonViewModel {
        randomElement(index: index, from: [
            RibbonViewModel(style: .success, title: "Aktiv"),
            RibbonViewModel(style: .disabled, title: "Inaktiv"),
            RibbonViewModel(style: .success, title: "Aktiv"),
            RibbonViewModel(style: .warning, title: "Solgt"),
        ])
    }

    static func randomElement<T>(index: Int, from values: [T]) -> T {
        values[index % values.count]
    }
}
