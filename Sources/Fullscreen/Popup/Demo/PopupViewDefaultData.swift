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
    public var callToActionButtonTitle = "Ja, takk"
    public var alternativeActionButtonTitle = "Nei takk"
    public var dismissButtonTitle: String? = "Spør senere"
    public var linkButtonTitle: String? = "Mer om anbefalinger"
    public var descriptionTitle = "Få personlige anbefalinger"
    public var descriptionText: String? = "Vi kan vise deg relevante FINN-annonser du ikke har sett. Da trenger vi å lagre dine søkevalg."
    public var attributedDescriptionText: NSAttributedString?
    public var image: UIImage = UIImage(named: "illustrasjonMedFarge")!

    public init() {}
}

struct PopupConsentViewDefaultDataRejected: PopupViewModel {
    public var callToActionButtonTitle = "Lukk"
    public var alternativeActionButtonTitle = "Angre"
    public var dismissButtonTitle: String?
    public var linkButtonTitle: String?
    public var descriptionTitle = "Personlige anbefalinger er slått av"
    public var descriptionText: String? = "Vi vil ikke lenger tipse deg om relevante annonser du ikke sett."
    public var attributedDescriptionText: NSAttributedString?
    public var image: UIImage = UIImage(named: "illustrasjonUtenFarge")!

    public init() {}
}

struct PopupConsentViewTransparency: PopupViewModel {
    public var callToActionButtonTitle = "Jeg forstår"
    public var alternativeActionButtonTitle = "Les mer"
    public var dismissButtonTitle: String?
    public var linkButtonTitle: String?
    public var descriptionTitle = "Dine data, dine valg"
    public var descriptionText: String?
    public var image: UIImage = UIImage(named: "consentTransparencyImage")!

    public var attributedDescriptionText: NSAttributedString? {
        let mutableAttributedString = NSMutableAttributedString()
        let firstParagraph = NSAttributedString(string: "Hei! For å gjøre FINN bedre samler vi inn informasjon fra alle dere som besøker oss. Vi bruker personlig informasjon og data for å:\n\n")
        let bulletPointArray: [String] = ["Kunne gi deg relevante anbefalinger og tips", "Sørge for at tjenesten FINN fungerer så bra som mulig", "Sikre at FINN er trygg plass å handle på"]
        let secondParagraph = NSAttributedString.makeBulletPointFrom(stringList: bulletPointArray, font: .detail, paragraphSpacing: .smallSpacing)
        let thirdParagraph = NSAttributedString(string: "\nNår du bruker FINN er Schibsted Norge (eieren vår) behandlingsansvarlig for påloggingsløsning og reklame, mens FINN er behandlingsansvarlig for det øvrige innholdet. Både FINN og Schibsted Norge behandler data om deg.")
        mutableAttributedString.append(firstParagraph)
        mutableAttributedString.append(secondParagraph)
        mutableAttributedString.append(thirdParagraph)
        return mutableAttributedString
    }

    public init() {}
}
