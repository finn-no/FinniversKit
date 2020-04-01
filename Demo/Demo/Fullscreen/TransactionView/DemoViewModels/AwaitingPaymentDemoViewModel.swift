//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var AwaitingPaymentDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        alert: TransactionAlertModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            body: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte.",
            imageIdentifier: "alert-multiple-contracts"
        ),

        steps: [
            TransactionStepModel(
                state: .completed,
                main: TransactionStepContentModel(
                    title: "Annonsen er lagt ut",
                    primaryButton: TransactionStepContentActionButtonModel(
                        text: "Se annonsen",
                        style: "flat",
                        action: "see_ad",
                        fallbackUrl: "/171529672"))),

            TransactionStepModel(
                state: .completed,
                main: TransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Begge har signert kontrakten."),
                    primaryButton: TransactionStepContentActionButtonModel(
                        text: "Gå til kontrakt",
                        style: "flat",
                        url: "https://www.google.com/search?q=contract+signed"))),

            TransactionStepModel(
                state: .active,
                main: TransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Venter på at kjøper skal betale."))),

            TransactionStepModel(
                state: .notStarted,
                main: TransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Dere må møtes og bekrefte overleveringen innen 7 dager etter kjøper har betalt.</p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens vegvesen.</li><li>Deretter må begge bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>"))),

            TransactionStepModel(
                state: .notStarted,
                main: TransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))),
    ])
}
