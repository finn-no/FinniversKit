//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct ConsentTransparencyInfoDefaultData: ConsentTransparencyInfoViewModel {
    public init() {}

    public var mainHeaderText = "Sikring og bruk av dine data"

    public var finnHeaderText = "Hva bruker FINN dataen til?"
    public var finnIntroText = "FINN bruker data om deg og hva du gjør på FINN til flere formål. De viktigste er:"
    public var finnBulletPointsText: NSAttributedString {
        let bulletPoints = [
            "Levere den tjenesten du forventer av oss: Vise frem annonser, sørge for medlingsutveksling og tilby søk og varslinger",
            "Gi deg tilpasset innhold: Vise søketrff nær deg, og anbefale relevant innhold. Dette kan vi vise på FINN, eller på andre nettsteder", "Annonsering, annonsevisninger og mulighet for å kontakte annonsør",
            "Forbedre produktene våre gjennom statistikk: Sjekke hvordan tjenesten fungerer, og måle effekten av endringer vi gjør",
            "Sikre en trygg markedsplass ved å forhindre svindel, brudd på annonsereglene og annen misbruk av tjenestene våre",
        ]
        return NSAttributedString.makeBulletPointFrom(stringList: bulletPoints, font: .body)
    }
    public var finnButtonIntroWithSettingsText = "Du kan endre innstillingene dine eller lese vår personvernerklæring her:"
    public var finnButtonIntroWithoutSettingsText = "Du kan lese vår personvernerklæring her:"
    public var finnSettingsButtonTitle = "Innstillinger på FINN"
    public var finnPrivacyButtonTitle = "Vår personvernerklæring"

    public var schibstedHeaderText = "Hva bruker Schibsted dataen til?"
    public var schibstedIntroText = "Schibsted Norge bruker data om deg og hva du gjør på FINN og andre Schibsted-tjenester primært for å"
    public var schibstedBulletPointsText: NSAttributedString {
        let bulletPoints = [
            "Tilby en trygg, enkel og effektiv påloggingstjeneste.",
            "Gi deg relevant reklameinnhold: Vi tror du setter mer pris på reklame som er tilpasset deg, enn tilfeldig reklame.",
        ]
        return NSAttributedString.makeBulletPointFrom(stringList: bulletPoints, font: .body)
    }
    public var schibstedButtonIntroWithSettingsText = "Du kan endre innstillingene dine eller lese Schibsted Norges personvernerklæring her:"
    public var schibstedButtonIntroWithoutSettingsText = "Du kan lese Schibsted Norges personvernerklæring her:"
    public var schibstedSettingsButtonTitle = "Innstillinger hos Schibsted"
    public var schibstedPrivacyButtonTitle = "Schibsteds personvernerklæring"
}
