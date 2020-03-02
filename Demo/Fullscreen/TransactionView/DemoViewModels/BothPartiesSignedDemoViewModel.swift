//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

extension TransactionDemoViewDefaultData {
    static var BothPartiesSignedDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imageUrlString: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        alert: TransactionWarningModel(
            title: "AlertTitle",
            message: "You have multiple contracts open"),

        steps: [
            TransactionStepModel(
                state: .completed,
                title: "Annonsen er lagt ut",
                primaryButton: TransactionStepPrimaryButtonModel(
                    text: "Se annonsen",
                    style: "flat",
                    action: "see_ad",
                    fallbackUrlString: "www.finn.no/171529672")),

            TransactionStepModel(
                state: .completed,
                title: "Kontrakt",
                body: "Begge har signert kontrakten.",
                primaryButton: TransactionStepPrimaryButtonModel(
                    text: "Gå til kontrakt",
                    style: "flat",
                    urlString: "https://www.google.com/search?q=contract+signed"
                )),

            TransactionStepModel(
                state: .active,
                title: "Betaling",
                body: "Før kjøper kan overføre pengene, må du forberede betalingen.",
                primaryButton: TransactionStepPrimaryButtonModel(
                    text: "Forbered betaling",
                    style: "call_to_action",
                    urlString: "https://www.google.com/search?q=contract+signed"
                )),

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
