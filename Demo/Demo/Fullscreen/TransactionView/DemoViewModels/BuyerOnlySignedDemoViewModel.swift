//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var BuyerOnlySignedDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        alert: TransactionAlertModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            message: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte.",
            imageIdentifier: "MULTIPLE-CONTRACTS"
        ),

        steps: [
            TransactionStepModel(
                state: .completed,
                style: .default,
                main: TransactionStepContentModel(
                    title: "Annonsen er lagt ut",
                    primaryButton: TransactionActionButtonModel(
                        text: "Se annonsen",
                        style: "FLAT",
                        action: "SEE_AD",
                        fallbackUrl: "/171529672"))),

            TransactionStepModel(
                state: .active,
                style: .default,
                main: TransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Kjøper har signert, nå mangler bare din signatur."),
                primaryButton: TransactionActionButtonModel(
                    text: "Signer kontrakt",
                    style: "CALL_TO_ACTION",
                    fallbackUrl: "https://www.google.com/search?q=contract+signed"))),

            TransactionStepModel(
                state: .notStarted,
                style: .default,
                main: TransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten."))),

            TransactionStepModel(
                state: .notStarted,
                style: .default,
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
