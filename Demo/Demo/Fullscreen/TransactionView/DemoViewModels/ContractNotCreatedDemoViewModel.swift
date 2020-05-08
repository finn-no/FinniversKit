//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var ContractNotCreatedDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        steps: [
            TransactionStepModel(
                state: .completed,
                main: TransactionStepContentModel(
                    title: "Annonsen er lagt ut",
                    primaryButton: TransactionActionButtonModel(
                        text: "Se annonsen",
                        style: "FLAT",
                        action: "SEE_AD",
                        fallbackUrl: "/171529672"))),

            TransactionStepModel(
                state: .active,
                main: TransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt."),
                    primaryButton: TransactionActionButtonModel(
                        text: "Opprett digital kontrakt",
                        style: "CALL_TO_ACTION",
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
