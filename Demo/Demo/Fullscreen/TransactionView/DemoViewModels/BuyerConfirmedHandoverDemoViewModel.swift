//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var BuyerConfirmedHandoverDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        alert: TransactionAlertModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            message: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte.",
            imageIdentifier: "MULTIPLE_CONTRACTS"
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
                state: .completed,
                style: .default,
                main: TransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Begge har signert kontrakten."),
                    primaryButton: TransactionActionButtonModel(
                        text: "Gå til kontrakt",
                        style: "FLAT",
                        url: "https://www.google.com/search?q=contract+signed"))),

            TransactionStepModel(
                state: .completed,
                main: TransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Kjøper betalte 1. februar 2020.")),
                detail: TransactionStepContentModel(
                    body: NSAttributedString(string: "Utbetalingen starter først når begge har bekreftet at overleveringen har skjedd."))),

            TransactionStepModel(
                state: .active,
                style: .default,
                main: TransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Kjøper har bekreftet.</p><p>Dere må bekrefte før:<br/><strong>8. februar 2020.</strong></p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens vegvesen.</li><li>Deretter må <strong>begge</strong> bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>"),
                    nativeButton: TransactionActionButtonModel(
                        text: "Registrer eierskifte",
                        style: "DEFAULT",
                        url: "https://www.vegvesen.no/"),
                    primaryButton: TransactionActionButtonModel(
                        text: "Bekreft overlevering",
                        style: "CALL_TO_ACTION",
                        action: "URL",
                        url: "https://www.google.com/search?q=contract+signed")),
                detail: TransactionStepContentModel(
                    body: NSAttributedString(string: "Hvis fristen går ut før dere har bekreftet, ta kontakt med Swiftcourt for å få pengene ut av hvelvet."))),

            TransactionStepModel(
                state: .notStarted,
                style: .default,
                main: TransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før».")),
                detail: TransactionStepContentModel(
                    body: NSAttributedString(string: "Det kan ta noen dager før pengene dukker opp på kontoen din."))),
    ])
}
