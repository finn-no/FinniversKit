//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct ConsentViewDefaultData: ConsentViewModel {
    public var image = UIImage(named: "page1", in: .playgroundBundle, compatibleWith: nil)
    public var yesButtonTitle = "Ja, det er greit"
    public var noButtonTitle = "Nei takk"
    public var cancelButtonTitle = "Avbryt"
    public var descriptionTitle = "Få anbefalinger der du er"
    public var descriptionIntroText = "Ved at vi tar vare på din"
    public var bulletPoints: [String] {
        let bulletPoint1 = "Søkehostorikk"
        let bulletPoint2 = "Lagrede søk"
        let bulletPoint3 = "Annonser du har besøkt"
        return [bulletPoint1, bulletPoint2, bulletPoint3]
    }

    public var descriptionText = "Kan vi vise deg innhold vi tror du ikke vil gå glipp av, når du er inne på FINN, Facebook, VG eller Aftenposten."

    public init() {}
}
