//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// A model confirming to the AdsGridViewModel protocol for showcasing AdsGridViewCell in playground.
public struct Ad: AdsGridViewModel {
    public enum AdType {
        case google
        case normal
    }

    public let imagePath: String?
    public let imageSize: CGSize
    public var iconImage: UIImage?
    public let title: String
    public let subtitle: String?
    public var accessory: String?
    public let imageText: String?
    public var isFavorite = false
    public var canScaleImageToFillView = true
    public var adType: AdType
    public var sponsoredAdData: SponsoredAdData?

    public var accessibilityLabel: String {
        var message = title

        if let subtitle = subtitle {
            message += ". " + subtitle
        }

        if let imageText = imageText {
            message += ". Pris: kroner " + imageText
        }

        return message
    }

    public var favoriteButtonAccessibilityLabel = "Sett annonsen som favoritt"
}

/// Creates Ads
public struct AdFactory {
    private struct ImageSource {
        let path: String
        let size: CGSize
    }

    private static var minimumDataItemsCount = { return min(titles.count, min(imageSources.count, min(prices.count, subtitles.count))) }()

    public static let googleDemoAd = Ad(
        imagePath: nil,
        imageSize: .zero,
        iconImage: nil,
        title: "Google Ad",
        subtitle: nil,
        accessory: nil,
        imageText: nil,
        isFavorite: false,
        adType: .google,
        sponsoredAdData: nil,
        favoriteButtonAccessibilityLabel: ""
    )

    public static func create(numberOfModels: Int) -> [Ad] {
        let sponsoredAdData = SponsoredAdData(
            ribbonTitle: "Betalt plassering",
            logoImagePath: "https://static.finncdn.no/_c/pf-logos/dnbnor_logo.png"
        )

        return (0 ..< numberOfModels).map { index in
            let dataIndex = index % minimumDataItemsCount
            let imageSource = imageSources[dataIndex]
            let title = titles[dataIndex]
            let subtitle = subtitles[dataIndex]
            let icon = iconImages[dataIndex]
            let price = prices[dataIndex]
            let canScaleImageToFillView = canScaleImagesToFillView[dataIndex]
            return Ad(
                imagePath: imageSource.path,
                imageSize: imageSource.size,
                iconImage: icon,
                title: title,
                subtitle: subtitle,
                accessory: index % 2 == 0 ? "Totalpris \(price)" : nil,
                imageText: price,
                isFavorite: false,
                canScaleImageToFillView: canScaleImageToFillView,
                adType: .normal,
                sponsoredAdData: index % 4 == 0 ? sponsoredAdData : nil,
                favoriteButtonAccessibilityLabel: "Sett annonsen som favoritt")
        }
    }

    private static var iconImages: [UIImage] {
        return [
            UIImage(named: .realestate),
            UIImage(named: .realestate),
            UIImage(named: .realestate),
            UIImage(named: .jobs),
            UIImage(named: .realestate),
            UIImage(named: .realestate),
            UIImage(named: .realestate),
            UIImage(named: .realestate),
            UIImage(named: .realestate)
        ]
    }

    private static var titles: [String] {
        return [
            "Home Sweet Home",
            "Hjemmekjært",
            "Villa Medusa",
            "Jobb i Schibsted",
            "Villa Villekulla",
            "Privat slott",
            "Pent brukt bolig",
            "Enebolig i rolig strøk",
            "Hus til slags"
        ]
    }

    private static var subtitles: [String] {
        return [
            "Oslo",
            "Bergen",
            "Trondheim",
            "Oslo",
            "Toten",
            "Nordkapp",
            "Langtvekkistan",
            "Elverum",
            "Brønnøysund",
            "Bodø"
        ]
    }

    private static var prices: [String] {
        return ["845 000,-",
                "164 000,-",
                "355 000,-",
                "",
                "746 000,-",
                "347 000,-",
                "546 000,-",
                "647 000,-",
                "264 000,-"]
    }

    private static var canScaleImagesToFillView: [Bool] {
        return [true,
                true,
                true,
                false,
                true,
                true,
                true,
                true,
                true,
                true,
                true]
    }

    private static var imageSources: [ImageSource] {
        return [
            ImageSource(path: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg", size: CGSize(width: 450, height: 354)),
            ImageSource(path: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg", size: CGSize(width: 800, height: 600)),
            ImageSource(path: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg", size: CGSize(width: 736, height: 566)),
            ImageSource(path: "https://static.schibsted.com/wp-content/uploads/2018/05/11085129/Schibsted_Logotype_L1_Dust-black_RGB-300x54.png", size: CGSize(width: 300, height: 54)),
            ImageSource(path: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg", size: CGSize(width: 550, height: 734)),
            ImageSource(path: "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg", size: CGSize(width: 1000, height: 672)),
            ImageSource(path: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg", size: CGSize(width: 1200, height: 800)),
            ImageSource(path: "http://www.discoverydreamhomes.com/wp-content/uploads/Model-Features-Copper-House.jpg", size: CGSize(width: 1000, height: 563)),
            ImageSource(path: "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg", size: CGSize(width: 640, height: 799)),
            ImageSource(path: "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg", size: CGSize(width: 523, height: 640)),
            ImageSource(path: "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg", size: CGSize(width: 1500, height: 1125))
        ]
    }
}
