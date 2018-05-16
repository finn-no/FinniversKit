//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public enum PopupConsentDefaultData {
    case reccomendations
    case reccomendationsRejected
    case transparency

    var model: PopupViewModel {
        switch self {
        case .reccomendations:
            return PopupConsentViewDefaultData()
        case .reccomendationsRejected:
            return PopupConsentViewDefaultDataRejected()
        case .transparency:
            return PopupConsentViewTransparency()
        }
    }
}

struct PopupConsentViewDefaultData: PopupViewModel {
    public var bottomRightButtonTitle = "Ja, takk"
    public var bottomLeftButtonTitle = "Nei takk"
    public var topRightButtonTitle: String? = "Spør senere"
    public var linkButtonTitle: String? = "Mer om anbefalinger"
    public var descriptionTitle = "Få personlige anbefalinger"
    public var descriptionText = "Vi kan vise deg relevante FINN-annonser du ikke har sett. Da trenger vi å lagre dine søkevalg."
    public var image: UIImage = UIImage(named: "illustrasjonMedFarge")!

    public init() {}
}

struct PopupConsentViewDefaultDataRejected: PopupViewModel {
    public var bottomRightButtonTitle = "Lukk"
    public var bottomLeftButtonTitle = "Angre"
    public var topRightButtonTitle: String?
    public var linkButtonTitle: String?
    public var descriptionTitle = "Personlige anbefalinger er slått av"
    public var descriptionText = "Vi vil ikke lenger tipse deg om relevante annonser du ikke sett."
    public var image: UIImage = UIImage(named: "illustrasjonUtenFarge")!

    public init() {}
}

struct PopupConsentViewTransparency: PopupViewModel {
    public var bottomRightButtonTitle = "Jeg forstår"
    public var bottomLeftButtonTitle = "Vis meg mer"
    public var topRightButtonTitle: String?
    public var linkButtonTitle: String?
    public var descriptionTitle = "Din data, dine valg"
    public var descriptionText = "FINN er en del av Schibsted Norge. Når du bruker FINN er Schibsted Norge behandlingsansvarlig for påloggingsløsning og reklame, mens FINN er behandlingsansvarlig for det øvrige innholdet i tjenesten vår. Både FINN og Schibsted Norge behandler data om deg.\n\nFINN bruker dine data til å tilpasse tjenestene til deg, mens Schibsted Norge i tillegg bruker dem til å gi deg mer relevante annonser. Persondata brukes også for å sikre at tjenestene er trygge og sikre for deg."
    public var image: UIImage = UIImage(named: "consentTransparencyImage")!

    public init() {}
}
