//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public struct UserAdCellViewModel: UserAdTableViewCellViewModel {
    public let titleText: String
    public let subtitleText: String?
    public let detailText: String?
    public let imagePath: String?
    public let ribbonViewModel: RibbonViewModel
    public var actionViewModel: UserAdTableViewCellActionViewModel?
    public var ratingViewModel: UserAdTableViewCellRatingViewModel?
}

public struct UserAdCellAction: UserAdTableViewCellActionViewModel {
    public let title: String?
    public let description: String
    public let buttonTitle: String
    public let cancelButtonTitle: String?
    public var isExternalAction: Bool
}

public struct UserAdCellRatingAction: UserAdTableViewCellRatingViewModel {
    public var title: String
    public var feedbackText: String
}

public struct UserAdsFactory {

    public static func createAds(includeEmphasized: Bool = false) -> [UserAdCellViewModel] {
        var ads = titles.enumerated().map {
            UserAdCellViewModel(
                titleText: $1,
                subtitleText: $0 == 3 ? nil : "Torget",
                detailText: details[$0],
                imagePath: imagePaths[$0],
                ribbonViewModel: ribbons[$0]
            )
        }

        if includeEmphasized {
            ads.insert(UserAdsFactory.createEmphasizedAd(), at: 0)
        }

        return ads
    }

    public static func createEmphasizedAd(hasExternalAction: Bool = false) -> UserAdCellViewModel {
        UserAdCellViewModel(
            titleText: "Rancho Cuccamonga",
            subtitleText: "Schmorget - Huh?",
            detailText: nil,
            imagePath: imagePaths[0],
            ribbonViewModel: RibbonViewModel(style: .success, title: "Aktiv"),
            actionViewModel: UserAdCellAction(
                title: "Her går det unna!",
                description: "Nå er det mange som selger Rancho Cuccamonga! For 89 kr kan du løfte annonsen din øverst i resultatlista, akkurat som da den var ny",
                buttonTitle: "Legg annonsen min øverst",
                cancelButtonTitle: "Nei takk",
                isExternalAction: hasExternalAction
            ),
            ratingViewModel: UserAdCellRatingAction(
                title: "Hva synes du om å få tips om produktkjøp til dine annonser på denne måten?",
                feedbackText: "Takk for tilbakemeldingen"
            )
        )
    }

    private static var imagePaths: [String] {
        return [
            "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
            "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
            "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
            "http://failing.example.com",
            "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        ]
    }

    private static var titles: [String] {
        return [
            "George Condo - My twisted fantasy is an incredibly sick fantasy",
            "Macbook Air - denne er så tynn at japanske kniver blir misunnelige",
            "Fender Jaguar Blå",
            "Nixon Kamera",
            "Retro sko",
            "Dette er en halvlang tittel med noe ekstra informasjon",
        ]
    }

    private static var prices: [String?] {
        return [
            "1 200 00 000 000 000 000 000 000,-",
            "1200 Kroner",
            "58 000 000 000 000,-",
            nil,
            "Gis bort",
            nil,
        ]
    }

    private static var details: [String] {
        return [
            "45 dager igjen",
            "12 dager igjen",
            "Sist redigert: 09.10.2019",
            "Sist redigert: 12.12.2015",
            "Sist redigert: 17.01.2019",
            "Sist redigert: 28.01.2019",
        ]
    }

    private static var statuses: [String] {
        return [
            "Påbegynt",
            "Venter på betaling",
            "Aktiv",
            "Deaktivert",
            "Solgt",
            "",
        ]
    }

    private static var ribbons: [RibbonViewModel] {
        return [
            RibbonViewModel(style: .success, title: "Avventer kontroll"),
            RibbonViewModel(style: .success, title: "Aktiv"),
            RibbonViewModel(style: .sponsored, title: "Solgt"),
            RibbonViewModel(style: .warning, title: "Påbegynt"),
            RibbonViewModel(style: .disabled, title: "Inaktiv"),
            RibbonViewModel(style: .success, title: "Avvist"),
        ]
    }
}
