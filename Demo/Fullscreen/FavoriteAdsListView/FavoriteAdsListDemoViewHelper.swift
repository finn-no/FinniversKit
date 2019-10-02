//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

extension FavoriteAdViewModel {
    static func deletedAd(addedToFolderDate: Date, ribbonStyle: RibbonView.Style, ribbonTitle: String) -> FavoriteAdViewModel {
        return self.init(
            addressText: nil,
            titleText: "Annonsen er slettet",
            titleColor: .textSecondary,
            descriptionPrimaryText: nil,
            descriptionSecondaryText: nil,
            descriptionTertiaryText: nil,
            imagePath: nil,
            ribbonStyle: ribbonStyle,
            ribbonTitle: ribbonTitle,
            sortingDetailText: nil,
            addedToFolderDate: addedToFolderDate,
            lastUpdated: nil,
            comment: nil
        )
    }
}

struct FavoriteAdsFactory {
    static func create() -> [FavoriteAdViewModel] {
        return titles.enumerated().map { (index, title) in
            guard let title = title else {
                return FavoriteAdViewModel.deletedAd(
                    addedToFolderDate: addedToFolderDates[index],
                    ribbonStyle: ribbonStyles[index].style,
                    ribbonTitle: ribbonStyles[index].title
                )
            }
            return FavoriteAdViewModel(
                addressText: addresses[index],
                titleText: title,
                titleColor: .textPrimary,
                descriptionPrimaryText: primaryDescriptions[index],
                descriptionSecondaryText: secondaryDescriptions[index],
                descriptionTertiaryText: tertiaryDescriptions[index],
                imagePath: imagePaths[index],
                ribbonStyle: ribbonStyles[index].style,
                ribbonTitle: ribbonStyles[index].title,
                sortingDetailText: sortingDetails[index],
                addedToFolderDate: addedToFolderDates[index],
                lastUpdated: nil,
                comment: comments[index]
            )
        }
    }

    private static var sortingDetails: [String?] {
        return [
            "Avtand: 8,8 km",
            nil,
            nil,
            "Oppdatert: 28. desember 2019",
            nil,
            nil,
            nil,
            nil
        ]
    }

    private static var addresses: [String?] {
        return [
            "Slottet",
            "Innkjøpsansvarlig, Acme Inc.",
            nil,
            "Asker",
            "Røros",
            "Fredrikstad",
            "Sentrum, Navn Navnesens vei 42A, 0001 Oslo",
            "Østkanten, Helsfyrsveien 10A, 1010 Oslo"
        ]
    }

    private static var titles: [String?] {
        return [
            "Påhengsmotor",
            "Kategoriansvarlig teknisk innkjøp",
            nil,
            "Godt brukt Sofa - pris kan diskuteres mot rask henting.",
            "Worcestershire bøll terrier valper. Leveringsklare fra 21. August 2019",
            "Nesten ny bil / Panorama - Se utstyr! Innbytte mulig 2014, 69 700 km, kr 999 500,-",
            "BUD INNKOMMET! Lekker tomannsbolig med 70 soverom. Nydelige uteplasser! Garasje med innredet hems.",
            "Nordvendt og lekkert rekkehus med mulighet for 2 soverom nær flotte t-baner og skoler."
        ]
    }

    private static var primaryDescriptions: [String?] {
        return [
            "15 001,-",
            "Kategoriansvarlig teknisk innkjøp",
            nil,
            "2 000,-",
            "17 000,-",
            "2014 • 69 700 km • 999 500,-",
            "128m² • 2 565 000,-",
            "123m² • 2 750 000,-"
        ]
    }

    private static var secondaryDescriptions: [String?] {
        return [
            "Båtmotor til salgs・Utenbords・60 hk",
            "Fulltidsstilling・Acme Inc.・Søknadsfrist 2020-02-31・Fast",
            nil,
            "Torget",
            "Torget",
            "Bruktbil・Bil・Bensin",
            "Bolig til salgs・Eier (Selveier)・Tomannsbolig",
            "Bolig til salgs・1 989,- pr mnd・Eier (Selveier)・Andre・1 soverom"
        ]
    }

    private static var tertiaryDescriptions: [String?] {
        return [
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            "Visning mandag 9. september kl. 14:00-16:00",
            "Visning mandag 9. september kl. 14:00-16:00",
        ]
    }

    private static var imagePaths: [String?] {
        return [
            "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
            "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
            nil,
            "http://jonvilma.com/images/house-6.jpg",
            "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
            "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
            "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg",
            "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg"
        ]
    }

    private static var comments: [String?] {
        return [
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            "Kjekk villa som kunne ha imponert venner og bekjente. Fantastisk hage for grillfester og sammenkomster. Trekker litt ned for gamle soilrør. Oppgradert i 1965.",
            nil
        ]
    }

    private static var ribbonStyles: [(style: RibbonView.Style, title: String)] {
        return [
            (style: .success, title: "Aktiv"),
            (style: .error, title: "Slettet"),
            (style: .error, title: "Slettet"),
            (style: .warning, title: "Solgt"),
            (style: .disabled, title: "Frist utløpt"),
            (style: .success, title: "Aktiv"),
            (style: .disabled, title: "Deaktivert"),
            (style: .warning, title: "Solgt")
        ]
    }

    private static var addedToFolderDates: [Date] {
        let referenceDate = Date(timeIntervalSince1970: 1564653600) // 2019-08-01T12:00:00+0200
        let oneDay: Double = 86400
        let oneWeek: Double = 86400 * 7
        let oneYear: Double = oneDay * 365
        return [
            referenceDate,
            referenceDate.addingTimeInterval(-oneDay),
            referenceDate.addingTimeInterval(-oneWeek),
            referenceDate.addingTimeInterval(-(oneWeek * 4)),
            referenceDate.addingTimeInterval(-(oneWeek * 26)),
            referenceDate.addingTimeInterval(-(oneYear)),
            referenceDate.addingTimeInterval(-(oneYear + oneWeek * 4)),
            referenceDate.addingTimeInterval(-(oneYear + oneWeek * 4))
        ]
    }
}
