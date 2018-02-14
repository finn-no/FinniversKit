//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct ConsentViewDefaultData: ConsentViewModel {
    public var image: UIImage?
    public var yesButtonTitle = "Ja, takk"
    public var noButtonTitle = "Nei, takk"
    public var cancelButtonTitle = "Hopp over" // "Utsett"
    public var descriptionTitle = "Få relevante anbefalinger, der du er"
    public var descriptionBodyText = "Er det greit at FINN lagrer opplysninger om hva du har gjort hos oss, og bruker informasjonen til å vise deg innhold du sannsynligvis er interessert i?\n\nDa kan vi anbefale deg FINN-annonser vi tror du ikke vil gå glipp av:\n- Når du er inne på FINN\n- Når du besøker andre tjenester som Facebook, VG og Aftenposten" // "Vil du være med på å få anbefalinger?"

    public init() {}
}
