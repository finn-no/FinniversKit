//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var BuyerInvitedDemoViewModel = TransactionModel(
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
                title: "Annonsen er lagt ut",
                primaryButton: TransactionStepActionButtonModel(
                    text: "Se annonsen",
                    style: "flat",
                    action: "see_ad",
                    fallbackUrl: "www.finn.no/171529672")),

            TransactionStepModel(
                state: .active,
                title: "Kontrakt",
                body: NSAttributedString(string: "Kjøper har blitt invitert."),
                primaryButton: TransactionStepActionButtonModel(
                    text: "Signer kontrakt",
                    style: "call_to_action",
                    url: "https://www.google.com/search?q=contract+signed")),

            TransactionStepModel(
                state: .notStarted,
                title: "Betaling",
                body: NSAttributedString(string: "Kjøper betalte 1. februar 2020"),
                detail: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten."),

            TransactionStepModel(
                state: .notStarted,
                title: "Overlevering",
                body: NSAttributedString(string: "<p>Velger dere å betale gjennom FINN, må overleveringen skje innen 7 dager etter kjøper har betalt.</p><p>Registrering av eierskiftet bør gjøres når dere møtes for overlevering.</p>")),

            TransactionStepModel(
                state: .notStarted,
                title: "Gratulerer med salget!",
                body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))
    ])
}
