//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct ConsentTransparencyInfoDefaultData: ConsentTransparencyInfoViewModel {
    public init() {}

    public var mainHeaderText = "Sikring og bruk av dine data"

    public var mainIntroText = "Når du bruker FINN, gir du oss og Schibsted Norge tilgang til opplysninger om deg. Her kan du lese hva vi bruker dem til."

    public var usageHeaderText = "Hva bruker FINN dataen til?"

    public var usageIntro1Text = "FINN bruker data om deg og hva du gjør på FINN til flere formål."

    public var usageIntro2Text = "Levere den tjenesten du forventer av oss"

    public var usageBulletPointsText: NSAttributedString {
        let bulletPoints = ["Annonsering, annonsevisninger og mulighet for å kontakte annonsør", "Meldingsutveksling", "Søk og varslinger", "Gi en best mulig tjeneste til deg, gjennom å tilpasse innholdet vårt. For eksempel ved å vektlegge søketreff nær der du bor.", "Anbefale innhold vi tror er interessant for deg. Dette innholdet kan vi vise på FINN, eller på andre nettsteder."]
        return NSAttributedString.makeBulletPointFrom(stringList: bulletPoints, font: .body)
    }

    public var improveHeaderText = "Forbedre produktene våre"

    public var improveIntroText = "Vi bruker statistikk og analyse som grunnlag for avgjørelser om hvilke endringer vi bør gjøre i tjenestene våre, og hvilken effekt endringene har. Sikre en trygg markedsplass ved å forhindre svindel, misbruk av tjenestene våre, eller brudd på annonsereglene."

    public var improveButtonIntroWithSettingsText = "Du kan endre innstillingene dine eller lese vår personvernerklæring ved å trykke knappene under dette avsnittet."

    public var improveButtonIntroWithoutSettingsText = "Du kan lese vår personvernerklæring her:"

    public var settingsFinnButtonTitle = "Innstillinger"

    public var privacyFinnButtonTitle = "Personvernerklæring"

    public var usageSchibstedHeaderText = "Hva bruker Schibsted dataen til?"

    public var usageSchibstedIntroText = "Schibsted Norge bruker data om deg og hva du gjør på FINN og andre Schibsted-tjenester primært for å"

    public var usageSchibstedBulletPointsText: NSAttributedString {
        let bulletPoints = ["Ivareta en trygg, enkel og effektiv påloggingstjeneste.", "Gi deg relevant reklameinnhold fremfor tilfeldig reklame."]
        return NSAttributedString.makeBulletPointFrom(stringList: bulletPoints, font: .body)
    }

    public var usageSchibstedButtonIntroWithSettingsText = "Du kan endre innstillingene dine eller lese Schibsted Norges personvernerklæring ved å trykke knappene under dette avsnittet."

    public var usageSchibstedButtonIntroWithoutSettingsText = "Du kan lese Schibsted Norges personvernerklæring her:"

    public var settingsSchibstedButtonTitle = "Innstillinger"

    public var privacySchibstedButtonTitle = "Personvernerklæring"
}
