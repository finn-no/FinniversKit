//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension MotorTransactionDefaultData {
    static var AdExpiredDemoViewModel = MotorTransactionModel(
        title: "Salgsprosess",

        header: MotorTransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        steps: [
            MotorTransactionStepModel(
                state: .active,
                style: .warning,
                main: MotorTransactionStepContentModel(
                    title: "Annonsen er utløpt",
                    body: NSAttributedString(string: "Legg ut annonsen på nytt, sånn at kjøpere kan ta kontakt med deg."),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Legg ut på nytt",
                        style: "CALL_TO_ACTION",
                        action: "REPUBLISH_AD",
                        fallbackUrl: "/user/ads/admin.html?finnkode=171529672")),
                detail: MotorTransactionStepContentModel(
                    title: "Ønsker du hjelp med salget?",
                    body: NSAttributedString(string: "Nettbil hjelper deg kostnadsfritt med å selge bilen til forhandlere gjennom en budrunde. De trenger bare levere deg bilen, så ordner Nettbil resten."),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Mer om Nettbil",
                        style: "DEFAULT",
                        fallbackUrl: "https://www.finn.no/nettbil/velkommen"))),

            MotorTransactionStepModel(
                state: .notStarted,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt."),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Opprett digital kontrakt",
                        style: "FLAT",
                        fallbackUrl: "https://www.google.com/search?q=contract+signed"))),

            MotorTransactionStepModel(
                state: .notStarted,
                main: MotorTransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten."))),

            MotorTransactionStepModel(
                state: .notStarted,
                main: MotorTransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Velger dere å betale gjennom FINN, må overleveringen skje innen 7 dager etter kjøper har betalt.</p><p>Registrering av eierskiftet bør gjøres når dere møtes for overlevering.</p>"))),

            MotorTransactionStepModel(
                state: .notStarted,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))),
    ])
}
