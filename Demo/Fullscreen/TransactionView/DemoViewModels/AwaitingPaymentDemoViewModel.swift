//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

extension TransactionDemoViewDefaultData {
    static var AwaitingPaymentDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imageUrl: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        warning: TransactionWarningModel(
            title: "Du har opprettet flere kontrakter for denne bilen",
            message: "En avtale er bindene når begge har signert. Prosessen under viser derfor prosessen for den første kontrakten begge signerte."),

        steps: [
            TransactionStepModel(
                state: .completed,
                title: "Annonsen er lagt ut",
                primaryButton: TransactionStepPrimaryButtonModel(
                    text: "Se annonsen",
                    style: "flat",
                    action: "see_ad",
                    fallbackUrl: "www.finn.no/171529672")),

            TransactionStepModel(
                state: .completed,
                title: "Kontrakt",
                body: "Begge har signert kontrakten.",
                primaryButton: TransactionStepPrimaryButtonModel(
                    text: "Gå til kontrakt",
                    style: "flat",
                    url: "https://www.google.com/search?q=contract+signed"
                )),

            TransactionStepModel(
                state: .active,
                title: "Betaling",
                body: "Venter på at kjøper skal betale."),

            TransactionStepModel(
                state: .notStarted,
                title: "Overlevering",
                body: "<p>Dere må møtes og bekrefte overleveringen innen 7 dager etter kjøper har betalt.</p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens vegvesen.</li><li>Deretter må begge bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>"),

            TransactionStepModel(
                state: .notStarted,
                title: "Gratulerer med salget!",
                body: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før».")
    ])
}
