//
//  Created by Saleh-Jan, Robin on 28/02/2020.
//

import Foundation.NSString

extension MotorTransactionDefaultData {
    static var BothPartiesConfirmedHandoverDemoViewModel = MotorTransactionModel(
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
                    body: NSAttributedString(string: "Kjøper betalte 1. februar 2020."))),

            MotorTransactionStepModel(
                state: .completed,
                main: MotorTransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "Dere har bekreftet at overleveringen har skjedd."))),

            MotorTransactionStepModel(
                state: .completed,
                style: .focus,
                main: MotorTransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «<a href=\"/minekjoretoy\">Eide før</a>»."),
                    nativeBody: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under Eide før.")),
                detail: MotorTransactionStepContentModel(
                    body: NSAttributedString(string: "Det kan ta noen dager før pengene dukker opp på kontoen din."),
                    nativeButton: MotorTransactionButtonModel(
                        text: "Gå til Mine kjøretøy",
                        style: "FLAT",
                        url: "/minekjoretoy"))),
    ])
}
