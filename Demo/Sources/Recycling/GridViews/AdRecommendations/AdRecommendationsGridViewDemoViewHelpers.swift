//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// A wrapper enum to have multiple types of view models in the AdRecommendationsGridViewDemoView data source
enum AdRecommendation {
    case ad(Ad)
    case job(JobAd)
    case external(ExternalAd)
}

/// A model confirming to the StandardAdRecommendationViewModel protocol for showcasing StandardAdRecommendationCell in playground.
public struct Ad: StandardAdRecommendationViewModel {
    public enum AdType {
        case native
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
    public var scaleImageToFillView = true
    public var adType: AdType
    public var sponsoredAdData: SponsoredAdData?
    public var favoriteButtonAccessibilityData: FavoriteButtonAccessibilityData = FavoriteButtonAccessibilityData(
        labelInactiveState: "Save to favorites. Heart icon.",
        labelActiveState: "Remove from favorites. Filled heart icon.",
        hint: "Tap to change favorite status."
    )
    public var badgeViewModel: BadgeViewModel? = nil
    public var companyName: String? = nil

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

    public var hideImageOverlay: Bool {
        imageText.isNilOrEmpty && iconImage == nil
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let value = self else {
            return true
        }
        return value.isEmpty
    }
}

/// A model confirming to the JobAdRecommendationViewModel protocol for showcasing JobAdRecommendationCell in playground.
struct JobAd: JobAdRecommendationViewModel {
    var id: String
    var title: String
    var company: String
    var location: String
    var publishedRelative: String?
    var ribbonOverlayModel: RibbonViewModel?
    var imagePath: String?
    var isFavorite: Bool = false
    var favoriteButtonAccessibilityData: FavoriteButtonAccessibilityData = FavoriteButtonAccessibilityData(
        labelInactiveState: "Save to favorites. Heart icon.",
        labelActiveState: "Remove from favorites. Filled heart icon.",
        hint: "Tap to change favorite status."
    )
}

/// Creates Ads
struct AdFactory {
    private struct ImageSource {
        let path: String
        let size: CGSize
    }

    private static var minimumDataItemsCount = { return min(titles.count, min(imageSources.count, min(prices.count, subtitles.count))) }()

    static var googleDemoAd = Ad(imagePath: nil, imageSize: .zero, title: "Google Ad", subtitle: nil, imageText: nil, adType: .google)
    static var nativeDemoAd = Ad(imagePath: nil, imageSize: .zero, title: "Native Ad", subtitle: nil, imageText: nil, adType: .native)

    static func create(numberOfModels: Int) -> [Ad] {
        let sponsoredAdData = SponsoredAdData(
            ribbonTitle: "Betalt plassering",
            logoImagePath: "https://static.finncdn.no/_c/pf-logos/dnbnor_logo.png"
        )
        let badgeViewModel = BadgeViewModel(style: .warning, title: "Fiks ferdig", icon: UIImage(named: .bapShippable))

        return (0 ..< numberOfModels).map { index in
            let dataIndex = index % minimumDataItemsCount
            let imageSource = imageSources[dataIndex]
            let title = titles[dataIndex]
            let subtitle = subtitles[dataIndex]
            let price = prices[dataIndex]
            let scaleImageToFillView = scaleImagesToFillView[dataIndex]

            return Ad(
                imagePath: imageSource.path,
                imageSize: imageSource.size,
                iconImage: nil,
                title: title,
                subtitle: subtitle,
                accessory: index % 2 == 0 ? "Totalpris \(price ?? "mangler")" : nil,
                imageText: price,
                isFavorite: false,
                scaleImageToFillView: scaleImageToFillView,
                adType: .normal,
                sponsoredAdData: index % 4 == 0 ? sponsoredAdData : nil,
                badgeViewModel: index == 1 ? badgeViewModel : nil
            )
        }
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
            "Hus til slags",
            "Hus",
            "Hus uten pris"
        ]
    }

    private static var subtitles: [String?] {
        return [
            "Oslo",
            nil,
            "Trondheim",
            "Oslo",
            "Toten",
            "Nordkapp",
            "Langtvekkistan",
            "Elverum",
            "Brønnøysund",
            "Bodø",
            "Langtvekkistan"
        ]
    }

    private static var prices: [String?] {
        return [
            "845 000,-",
            "164 000,-",
            "355 000,-",
            "",
            "746 000,-",
            "347 000,-",
            "546 000,-",
            "647 000,-",
            "264 000,-",
            "123 456,-",
            nil
        ]
    }

    private static var scaleImagesToFillView: [Bool] {
        return [
            true,
            true,
            true,
            false,
            true,
            true,
            true,
            true,
            true,
            true,
            true
        ]
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

struct JobAdFactory {
    static func create(numberOfModels: Int) -> [JobAd] {
        return (0 ..< numberOfModels).map { index in
            let dataIndex = index % title.count

            return JobAd(
                id: id[dataIndex],
                title: title[dataIndex],
                company: company[dataIndex],
                location: location[dataIndex],
                publishedRelative: time[dataIndex].isEmpty ? nil : "3 \(time[dataIndex])",
                ribbonOverlayModel: dataIndex % 2 == 0 ? RibbonViewModel(style: .success, title: "Enkel søknad") : nil,
                imagePath: "https://static.schibsted.com/wp-content/uploads/2018/05/11085129/Schibsted_Logotype_L1_Dust-black_RGB-300x54.png",
                isFavorite: false
            )
        }
    }

    private static let id: [String] = [
        "1",
        "2",
        "3",
        "4"
    ]

    private static let title: [String] = [
        "Vi søker deg som er virkelig brenner for faget og har store ambisjoner!",
        "Fullstack utvikler med muligheter for lederrolle",
        "Rancho Cuccamonga søker mederbeider til renholdsavdelingen i 60% stilling",
        "Reodor Felgen søker mekaniker til å fikse superretometerfordeler"
    ]

    private static let company: [String] = [
        "FINN.no AS",
        "Selskap med veldig langt navn",
        "Rancho Cuccamonga AS",
        "Reodors sykkelverksted"
    ]

    private static let location: [String] = [
        "Oslo",
        "Kristiansand",
        "Neverland",
        "Flåklypa"
    ]

    private static let time: [String] = [
        "minutter siden",
        "",
        "uker siden",
        "måneder siden"
    ]
}

/// A model confirming to the ExternalAdRecommendationViewModel protocol for showcasing ExternalAdRecommendationCell in playground.
struct ExternalAd: ExternalAdRecommendationViewModel {
    var ribbonViewModel: RibbonViewModel?
    var imageSize: CGSize
    var iconImage: UIImage?
    var subtitle: String?
    var accessory: String?
    var imageText: String?
    var scaleImageToFillView: Bool
    var hideImageOverlay: Bool
    var title: String
    var publishedRelative: String?
    var ribbonOverlayModel: RibbonViewModel?
    var imagePath: String?
}
struct ExternalAdFactory {

    private static var minimumDataItemsCount = { return min(titles.count, min(imageSources.count, min(prices.count, subtitles.count))) }()
    private struct ImageSource {
        let path: String
        let size: CGSize
    }

    static func create(numberOfModels: Int) -> [ExternalAd] {


        return (0 ..< numberOfModels).map { index in
            let dataIndex = index % minimumDataItemsCount
            let imageSource = imageSources[dataIndex]
            let title = titles[dataIndex]
            let subtitle = subtitles[dataIndex]
            let scaleImageToFillView = scaleImagesToFillView[dataIndex]

            return ExternalAd(
                ribbonViewModel: ribbons[dataIndex],
                imageSize: imageSource.size,
                subtitle: subtitle,
                scaleImageToFillView: scaleImageToFillView,
                hideImageOverlay: true,
                title: title,
                imagePath: imageSource.path
            )
        }
    }

    private static var ribbons: [RibbonViewModel] {
        return [
            RibbonViewModel(
                style: .default, title: "Nyttige Artikler"),
            RibbonViewModel(
                style: .sponsored, title: "Nyttige Artikler"),
            RibbonViewModel(
                style: .default, title: "Nyttige Artikler"),
            RibbonViewModel(
                style: .warning, title: ""),
        ]
    }

    private static var titles: [String] {
        return [
            "Dette kan du lære",
            "Kreta med barn - de beste tipsene",
            "Jobb her og bli lykkeligere",
            "Hotell i særklasse",
        ]
    }

    private static var subtitles: [String] {
        return [
            "",
            "",
            "",
            "Oslo",
        ]
    }

    private static var prices: [String?] {
        return [
            "845 000,-",
            "164 000,-",
            "",
            nil
        ]
    }

    private static var scaleImagesToFillView: [Bool] {
        return [
            true,
            true,
            true,
            true,
        ]
    }

    private static var imageSources: [ImageSource] {
        return [
            ImageSource(path: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg", size: CGSize(width: 450, height: 354)),
            ImageSource(path: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg", size: CGSize(width: 800, height: 600)),
            ImageSource(path: "https://finn-content-hub.imgix.net/bilder/Jobb/Jobb-uke-1-3/topp-10.jpg?auto=compress%2Cformat&crop=focalpoint&domain=finn-content-hub.imgix.net&fit=crop&fp-x=0.5&fp-y=0.5&h=360&ixlib=php-3.3.1&w=360", size: CGSize(width: 360, height: 360)),
            ImageSource(path: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg", size: CGSize(width: 736, height: 566)),
        ]
    }
}
