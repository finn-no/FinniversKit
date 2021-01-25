//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension MotorTransactionDefaultData {
    static var WaitingForBuyerToPayWithInsurance = MotorTransactionModel(
        title: "Kjøpsprosess",

        header: MotorTransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        steps: [
            MotorTransactionStepModel(
                state: .completed,
                main: MotorTransactionStepContentModel(
                    title: "Du har funnet en bil",
                    primaryButton: MotorTransactionButtonModel(
                        text: "Se annonsen",
                        style: "FLAT",
                        action: "SEE_AD",
                        fallbackUrl: "/171529672"))),

            MotorTransactionStepModel(
                state: .completed,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Kontrakt",
                    body: NSAttributedString(string: "Begge har signert kontrakten"),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Gå til kontrakt",
                        style: "FLAT",
                        fallbackUrl: "https://www.google.com/search?q=contract+signed"))),

            MotorTransactionStepModel(
                state: .completed,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Forsikring",
                    body: NSAttributedString(string: "Du har bestilt forsikring:")
                ),
                detail: MotorTransactionStepContentModel(
                    body: NSAttributedString(string: "<p>IF</p><p>Fri start Kasko • 30 dager til 0 kr • Egenandel: 4 000</p>"),
                    imageUrl: URL(string: "https://www.finn.no/pf-logos/disc/if")
                )),

            MotorTransactionStepModel(
                state: .active,
                main: MotorTransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Venter på at selger fyller inn sine kontodetaljer."))),

            MotorTransactionStepModel(
                state: .notStarted,
                style: .default,
                main: MotorTransactionStepContentModel(
                    title: "Overlevering",
                    body: NSAttributedString(string: "<p>Dere må møtes og bekrefte overleveringen innen 7 dager etter kjøper har betalt.</p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens Vegvesen.</li><li>Deretter må begge bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>"))),

            MotorTransactionStepModel(
                state: .notStarted,
                main: MotorTransactionStepContentModel(
                    title: "Gratulerer med salget!",
                    body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))),
    ])
}
