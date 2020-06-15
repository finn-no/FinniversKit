//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Foundation

public struct BapAdViewModel {
    public let id: String
    public let title: String
    public let price: String?
    public let author: AuthorViewModel
    public let description: DescriptionViewModel?
    public let extras: [ExtraViewModel]
    public let lastModified: String
    public let tryHeltHjem: TryHeltHjemViewModel?
    public let locationText: String

    public let phoneNumber: PhoneNumberViewModel?
    public let imageUrls: [URL]

    // MARK: - Static text
    public let addToFavoritesButtonTitle: String
    public let sendMessageButtonTitle: String

    public let loanPriceTitle: String
    public let reportAdTitle: String

    public let finnCode: String
    public let lastModifiedTitle: String
    public let similarAdsTitle: String

    public init(
        id: String,
        title: String,
        price: String?,
        author: AuthorViewModel,
        description: DescriptionViewModel?,
        extras: [ExtraViewModel],
        lastModified: String,
        tryHeltHjem: TryHeltHjemViewModel?,
        locationText: String,
        phoneNumber: PhoneNumberViewModel?,
        imageUrls: [URL],
        addToFavoritesButtonTitle: String,
        sendMessageButtonTitle: String,
        loanPriceTitle: String,
        reportAdTitle: String,
        finnCode: String,
        lastModifiedTitle: String,
        similarAdsTitle: String
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.author = author
        self.description = description
        self.extras = extras
        self.lastModified = lastModified
        self.tryHeltHjem = tryHeltHjem
        self.locationText = locationText
        self.phoneNumber = phoneNumber
        self.imageUrls = imageUrls
        self.addToFavoritesButtonTitle = addToFavoritesButtonTitle
        self.sendMessageButtonTitle = sendMessageButtonTitle
        self.loanPriceTitle = loanPriceTitle
        self.reportAdTitle = reportAdTitle
        self.finnCode = finnCode
        self.lastModifiedTitle = lastModifiedTitle
        self.similarAdsTitle = similarAdsTitle
    }
}

public struct ExtraViewModel {
    public let id: String
    public let label: String
    public let value: String

    public init(id: String, label: String, value: String) {
        self.id = id
        self.label = label
        self.value = value
    }
}

// Internal sample data for previews
extension BapAdViewModel {
    static let sampleData: BapAdViewModel = BapAdViewModel(
        id: "12345678",
        title: "Spinningsykkel Sole SB700 (inkl. treningsmatte og iPad holder)",
        price: "6 000 kr",
        author: .sampleData,
        description: .sampleData,
        extras: [ExtraViewModel(id: "condition", label: "Tilstand", value: "Brukt")],
        lastModified: "2",
        tryHeltHjem: .sampleData,
        locationText: "1333 Østerås",
        phoneNumber: .sampleData,
        imageUrls: [
            URL(string: "https://images.finncdn.no/dynamic/default/2020/4/vertical-0/24/3/176/687/643_2031068495.png")!,
            URL(string: "https://images.finncdn.no/dynamic/default/2020/4/vertical-0/24/3/176/687/643_1548519766.png")!,
            URL(string: "https://images.finncdn.no/dynamic/default/2020/4/vertical-0/24/3/176/687/643_1415599287.png")!,
        ],
        addToFavoritesButtonTitle: "Lagt til som favoritt",
        sendMessageButtonTitle: "Send melding",
        loanPriceTitle: "Pris på lån",
        reportAdTitle: "Rapporter svindel/regelbrudd",
        finnCode: "FINN-kode",
        lastModifiedTitle: "Sist endret",
        similarAdsTitle: "Lignende annonser"
    )
}
