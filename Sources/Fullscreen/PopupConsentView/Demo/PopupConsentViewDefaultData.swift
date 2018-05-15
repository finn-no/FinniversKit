//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public enum PopupConsentDefaultData {
    case reccomendations
    case reccomendationsRejected
    case transparency

    var model: PopupConsentViewModel {
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

struct PopupConsentViewDefaultData: PopupConsentViewModel {
    public var yesButtonTitle = "Ja, takk"
    public var noButtonTitle = "Nei takk"
    public var cancelButtonTitle: String? = "Spør senere"
    public var infoButtonTitle: String? = "Mer om anbefalinger"
    public var descriptionTitle = "Få personlige anbefalinger"
    public var descriptionText = "Vi kan vise deg relevante FINN-annonser du ikke har sett. Da trenger vi å lagre dine søkevalg."
    public var image: UIImage = UIImage(named: "illustrasjonMedFarge")!

    public init() {}
}

struct PopupConsentViewDefaultDataRejected: PopupConsentViewModel {
    public var yesButtonTitle = "Lukk"
    public var noButtonTitle = "Angre"
    public var cancelButtonTitle: String?
    public var infoButtonTitle: String?
    public var descriptionTitle = "Personlige anbefalinger er slått av"
    public var descriptionText = "Vi vil ikke lenger tipse deg om relevante annonser du ikke sett."
    public var image: UIImage = UIImage(named: "illustrasjonUtenFarge")!

    public init() {}
}

struct PopupConsentViewTransparency: PopupConsentViewModel {
    public var yesButtonTitle = "Jeg forstår"
    public var noButtonTitle = "Vis meg mer"
    public var cancelButtonTitle: String?
    public var infoButtonTitle: String?
    public var descriptionTitle = "Din data, dine valg"
    public var descriptionText = "FINN er en del av Schibsted Norge. Når du bruker FINN er Schibsted Norge behandlingsansvarlig for påloggingsløsning og reklame, mens FINN er behandlingsansvarlig for det øvrige innholdet i tjenesten vår. Både FINN og Schibsted Norge behandler data om deg.\n\nFINN bruker dine data til å tilpasse tjenestene til deg, mens Schibsted Norge i tillegg bruker dem til å gi deg mer relevante annonser. Persondata brukes også for å sikre at tjenestene er trygge og sikre for deg."
    public var image: UIImage = UIImage(named: "consentTransparencyImage")!

    public init() {}
}
