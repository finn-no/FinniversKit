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
            return ConsentTransparencyViewModel()
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
