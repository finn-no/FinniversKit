//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

import Foundation.NSString

extension MotorTransactionDefaultData {
    static var SellerConfirmedHandoverDemoViewModel = MotorTransactionModel(
        title: "Salgsprosess",

        header: MotorTransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        alert: MotorTransactionAlertModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            message: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte.",
            imageIdentifier: "MULTIPLE_CONTRACTS"
        ),

        steps: [
            MotorTransactionStepModel(
                state: .completed,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Annonsen er lagt ut",
                    primaryButton: MotorTransactionButtonModel(
                        text: "Se annonsen",
                        style: "FLAT",
                        action: "SEE_AD",
                        fallbackUrl: "/171529672"))),

            MotorTransactionStepModel(
                state: .completed,
                main: MotorTransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Begge har signert kontrakten."),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Gå til kontrakt",
                        style: "FLAT",
                        url: "https://www.google.com/search?q=contract+signed"))),

            MotorTransactionStepModel(
                state: .completed,
                main: MotorTransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Kjøper betalte 1. februar 2020.")),
                detail: MotorTransactionStepContentModel(
                    body: NSAttributedString(string: "Utbetalingen starter først når begge har bekreftet at overleveringen har skjedd."))),

            MotorTransactionStepModel(
                state: .active,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Du har bekreftet overleveringen.<br/>Venter på kjøper.</p><p>Dere må bekrefte før:<br/><strong>8. februar 2020.</strong></p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens vegvesen.</li><li>Deretter må <strong>begge</strong> bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>"),
                    nativeButton: MotorTransactionButtonModel(
                        text: "Registrer eierskifte",
                        style: "DEFAULT",
                        url: "https://www.vegvesen.no/"),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Bekreft overlevering",
                        style: "CALL_TO_ACTION",
                        action: "URL",
                        url: "https://www.google.com/search?q=contract+signed")),
                detail: MotorTransactionStepContentModel(
                    body: NSAttributedString(string: "Hvis fristen går ut før dere har bekreftet, ta kontakt med Swiftcourt for å få pengene ut av hvelvet."))),

                MotorTransactionStepModel(
                    state: .notStarted,
                    style: .default,
                    main: MotorTransactionStepContentModel(
                        title: "Gratulerer med salget!",
                        body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før».")),
                    detail: MotorTransactionStepContentModel(
                        body: NSAttributedString(string: "Det kan ta noen dager før pengene dukker opp på kontoen din."))),
    ])
}
