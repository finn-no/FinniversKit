//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var AdExpiredDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        steps: [
            TransactionStepModel(
                state: .active,
                style: .warning,
                main: TransactionStepContentModel(
                    title: "Annonsen er utløpt",
                    body: NSAttributedString(string: "Legg ut annonsen på nytt, sånn at kjøpere kan ta kontakt med deg."),
                    primaryButton: TransactionStepContentActionButtonModel(
                        text: "Legg ut på nytt",
                        style: "call_to_action",
                        action: "republish_ad",
                        fallbackUrl: "/user/ads/admin.html?finnkode=171529672")),
                detail: TransactionStepContentModel(
                    title: "Ønsker du hjelp med salget?",
                    body: NSAttributedString(string: "Nettbil hjelper deg kostnadsfritt med å selge bilen til forhandlere gjennom en budrunde. De trenger bare levere deg bilen, så ordner Nettbil resten."),
                    primaryButton: TransactionStepContentActionButtonModel(
                        text: "Mer om Nettbil",
                        style: "default",
                        fallbackUrl: "https://www.finn.no/nettbil/velkommen"))),

            TransactionStepModel(
                state: .notStarted,
                main: TransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt."),
                    primaryButton: TransactionStepContentActionButtonModel(
                        text: "Opprett digital kontrakt",
                        style: "flat",
                        fallbackUrl: "https://www.google.com/search?q=contract+signed"))),

            TransactionStepModel(
                state: .notStarted,
                main: TransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten."))),

            TransactionStepModel(
                state: .notStarted,
                main: TransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Velger dere å betale gjennom FINN, må overleveringen skje innen 7 dager etter kjøper har betalt.</p><p>Registrering av eierskiftet bør gjøres når dere møtes for overlevering.</p>"))),

            TransactionStepModel(
                state: .notStarted,
                main: TransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))),
    ])
}
