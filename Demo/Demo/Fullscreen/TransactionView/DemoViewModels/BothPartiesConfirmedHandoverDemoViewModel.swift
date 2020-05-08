//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var BothPartiesConfirmedHandoverDemoViewModel = TransactionModel(
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
                main: TransactionStepContentModel(
                    title: "Annonsen er lagt ut",
                    primaryButton: TransactionActionButtonModel(
                        text: "Se annonsen",
                        style: "FLAT",
                        action: "SEE_AD",
                        fallbackUrl: "/171529672"))),

            TransactionStepModel(
                state: .completed,
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
                    body: NSAttributedString(string: "Kjøper betalte 1. februar 2020."))),

            TransactionStepModel(
                state: .completed,
                main: TransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "Dere har bekreftet at overleveringen har skjedd."))),

            TransactionStepModel(
                state: .active,
                main: TransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «<a href=\"/minekjoretoy\">Eide før</a>»."),
                    nativeBody: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under Eide før.")),
                detail: TransactionStepContentModel(
                    body: NSAttributedString(string: "Det kan ta noen dager før pengene dukker opp på kontoen din."),
                    nativeButton: TransactionActionButtonModel(
                        text: "Gå til Mine kjøretøy",
                        style: "FLAT",
                        url: "/minekjoretoy"))),
    ])
}
