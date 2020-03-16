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

        warning: TransactionWarningModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            message: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte.",
            imageUrl: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Avocado.jpeg"),

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
                state: .completed,
                title: "Kontrakt",
                body: NSAttributedString(string: "Begge har signert kontrakten."),
                primaryButton: TransactionStepActionButtonModel(
                    text: "Gå til kontrakt",
                    style: "flat",
                    url: "https://www.google.com/search?q=contract+signed"
                )),

            TransactionStepModel(
                state: .completed,
                title: "Betaling",
                body: NSAttributedString(string: "Kjøper betalte 1. februar 2020."),
                detail: "Utbetalingen starter først når begge har bekreftet at overleveringen har skjedd."),

            TransactionStepModel(
                state: .active,
                title: "Overlevering",
                body: NSAttributedString(string: "<p>Kjøper har bekreftet.</p><p>Dere må bekrefte før:<br/><strong>8. februar 2020.</strong></p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens vegvesen.</li><li>Deretter må <strong>begge</strong> bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>"),
                primaryButton: TransactionStepActionButtonModel(
                    text: "Bekreft overlevering",
                    style: "call_to_action",
                    action: "url",
                    url: "https://www.vegvesen.no/"),
                secondaryButton: TransactionStepActionButtonModel(
                    text: "Registrer eierskifte",
                    style: "default",
                    url: "https://www.vegvesen.no/"
                ),
                detail: "Hvis fristen går ut før dere har bekreftet, ta kontakt med Swiftcourt for å få pengene ut av hvelvet."),

            TransactionStepModel(
                state: .notStarted,
                title: "Gratulerer med salget!",
                body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."),
                detail: "Det kan ta noen dager før pengene dukker opp på kontoen din.")
    ])
}
