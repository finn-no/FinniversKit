//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension MotorTransactionDefaultData {
    static var BuyerInvitedDemoViewModel = MotorTransactionModel(
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
                main: MotorTransactionStepContentModel(
                    title: "Annonsen er lagt ut",
                    primaryButton: MotorTransactionButtonModel(
                        text: "Se annonsen",
                        style: "FLAT",
                        action: "SEE_AD",
                        fallbackUrl: "/171529672"))),

            MotorTransactionStepModel(
                state: .active,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Kjøper har blitt invitert."),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Signer kontrakt",
                        style: "CALL_TO_ACTION",
                        fallbackUrl: "https://www.google.com/search?q=contract+signed"))),

            MotorTransactionStepModel(
                state: .notStarted,
                main: MotorTransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten."))),

            MotorTransactionStepModel(
                state: .notStarted,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Velger dere å betale gjennom FINN, må overleveringen skje innen 7 dager etter kjøper har betalt.</p><p>Registrering av eierskiftet bør gjøres når dere møtes for overlevering.</p>"))),

            MotorTransactionStepModel(
                state: .notStarted,
                main: MotorTransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))),
    ])
}
