//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct WishList: WishListViewModel {
    public var imagePath: String?
    public var imageSize: CGSize
    public var leftImageDetail: String
    public var rightImageDetail: String
    public var leftSubtitleDetail: String
    public var rightSubtitleDetail: String
    public var title: String
    
    public var accessibilityLabel: String {
        var message = leftImageDetail
        message += ". " + rightImageDetail
        message += ". " + leftSubtitleDetail
        message += ". " + rightSubtitleDetail
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
        let leftImageDetail: String
        let rightImageDetail: String
        let leftSubtitleDetail: String
        let rightSubtitleDetail: String
    }
    
    public static func create() -> [WishList] {
        var wishlist: [WishList] = []
        
        for index in 0 ... 4 {
            let imageSource = images[index]
            let detail = details[index]
            let title = titles[index]
            let wish = WishList(imagePath: imageSource.path, imageSize: imageSource.size, leftImageDetail: detail.leftImageDetail, rightImageDetail: detail.rightImageDetail, leftSubtitleDetail: detail.leftSubtitleDetail, rightSubtitleDetail: detail.rightSubtitleDetail, title: title)
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
            Detail(leftImageDetail: "20 500,-", rightImageDetail: "Aktiv", leftSubtitleDetail: "2 timer siden", rightSubtitleDetail: "Bergen"),
            Detail(leftImageDetail: "5000,-", rightImageDetail: "Inaktiv", leftSubtitleDetail: "10 timer siden", rightSubtitleDetail: "Oslo"),
            Detail(leftImageDetail: "3000,-", rightImageDetail: "Inaktiv", leftSubtitleDetail: "15 timer siden", rightSubtitleDetail: "Trondheim"),
            Detail(leftImageDetail: "120,-", rightImageDetail: "Aktiv", leftSubtitleDetail: "48 timer siden", rightSubtitleDetail: "Akershus"),
            Detail(leftImageDetail: "500,-", rightImageDetail: "Inaktiv", leftSubtitleDetail: "1 time siden", rightSubtitleDetail: "Stavanger")
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
