//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct WishList: WishListViewModel {
    public var imagePath: String?
    public var imageSize: CGSize
    public var priceLabel: String
    public var statusLabel: String
    public var recentUpdateLabel: String
    public var locationLabel: String
    public var title: String
    
    public var accessibilityLabel: String {
        var message = priceLabel
        message += ". " + statusLabel
        message += ". " + recentUpdateLabel
        message += ". " + locationLabel
        message += ". " + title
        return message
    }
}

public struct WishListFactory {
    private struct ImageSource {
        let path: String
        let size: CGSize
    }
    
    private struct Detail {
        let priceLabel: String
        let statusLabel: String
        let recentUpdateLabel: String
        let locationLabel: String
    }
    
    public static func create() -> [WishList] {
        var wishlist: [WishList] = []
        
        for index in 0 ... 4 {
            let imageSource = images[index]
            let detail = details[index]
            let title = titles[index]
            let wish = WishList(imagePath: imageSource.path, imageSize: imageSource.size, priceLabel: detail.priceLabel, statusLabel: detail.statusLabel,
                                recentUpdateLabel: detail.recentUpdateLabel, locationLabel: detail.locationLabel, title: title)
            wishlist.append(wish)
        }
        
        return wishlist
    }
    
    private static var titles: [String] = {
        return [
            "Aerodynamisk sykkel",
            "Stuebord",
            "Marmor pidestal",
            "Fuglebur",
            "Moderne sengetøy",
        ]
    }()
    
    private static var details: [Detail] = {
        return [
            Detail(priceLabel: "20 500,-", statusLabel: "Aktiv", recentUpdateLabel: "2 timer siden", locationLabel: "Bergen"),
            Detail(priceLabel: "5000,-", statusLabel: "Inaktiv", recentUpdateLabel: "10 timer siden", locationLabel: "Oslo"),
            Detail(priceLabel: "3000,-", statusLabel: "Inaktiv", recentUpdateLabel: "15 timer siden", locationLabel: "Trondheim"),
            Detail(priceLabel: "120,-", statusLabel: "Aktiv", recentUpdateLabel: "48 timer siden", locationLabel: "Akershus"),
            Detail(priceLabel: "500,-", statusLabel: "Inaktiv", recentUpdateLabel: "1 time siden", locationLabel: "Stavanger")
        ]
    }()
    
    private static var images: [ImageSource] = {
        return [
            ImageSource(path: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg", size: CGSize(width: 450, height: 354)),
            ImageSource(path: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg", size: CGSize(width: 800, height: 600)),
            ImageSource(path: "http://jonvilma.com/images/house-6.jpg", size: CGSize(width: 992, height: 546)),
            ImageSource(path: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg", size: CGSize(width: 736, height: 566)),
            ImageSource(path: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg", size: CGSize(width: 550, height: 734))
        ]
    }()
}
