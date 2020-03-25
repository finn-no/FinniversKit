//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var ContractCreatedDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        alert: TransactionAlertModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            body: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte.",
            imageIdentifier: "alert-multiple-contracts"
        ),

        steps: [
            TransactionStepModel(
                state: .completed,
                title: "Annonsen er lagt ut",
                primaryButton: TransactionStepActionButtonModel(
                    text: "Se annonsen",
                    style: "flat",
                    action: "see_ad",
                    fallbackUrl: "www.finn.no/171529672")),

            TransactionStepModel(
                state: .active,
                title: "Kontrakt",
                body: NSAttributedString(string: "Du har opprettet kontrakt."),
                primaryButton: TransactionStepActionButtonModel(
                    text: "Inviter kjøper",
                    style: "call_to_action",
                    url: "https://www.google.com/search?q=contract+signed")),

            TransactionStepModel(
                state: .notStarted,
                title: "Betaling",
                body: NSAttributedString(string: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten.")),

            TransactionStepModel(
                state: .notStarted,
                title: "Overlevering",
                body: NSAttributedString(string: "<p>Velger dere å betale gjennom FINN, må overleveringen skje innen 7 dager etter kjøper har betalt.</p><p>Registrering av eierskiftet bør gjøres når dere møtes for overlevering.</p>")),

            TransactionStepModel(
                state: .notStarted,
                title: "Gratulerer med salget!",
                body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før».")),
    ])
}
