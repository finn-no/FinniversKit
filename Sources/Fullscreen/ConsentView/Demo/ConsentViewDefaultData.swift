//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct ConsentViewDefaultData: ConsentViewModel {
    public var yesButtonTitle = "Ja, takk"
    public var noButtonTitle = "Nei takk"
    public var cancelButtonTitle: String? = "Spør senere"
    public var infoButtonTitle: String? = "Mer om anbefalinger"
    public var descriptionTitle = "Få personlige anbefalinger"
    public var descriptionText = "Vi kan vise deg relevante FINN-annonser du ikke har sett. Da trenger vi å lagre dine søkevalg."
    public var image: UIImage = UIImage(named: "illustrasjonMedFarge")!

    public init() {}
}

public struct ConsentViewDefaultDataRejected: ConsentViewModel {
    public var yesButtonTitle = "Lukk"
    public var noButtonTitle = "Angre"
    public var cancelButtonTitle: String?
    public var infoButtonTitle: String?
    public var descriptionTitle = "Personlige anbefalinger er slått av"
    public var descriptionText = "Vi vil ikke lenger tipse deg om relevante annonser du ikke sett."
    public var image: UIImage = UIImage(named: "illustrasjonUtenFarge")!

    public init() {}
}
