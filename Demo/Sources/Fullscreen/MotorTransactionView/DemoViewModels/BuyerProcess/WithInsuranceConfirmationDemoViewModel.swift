//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension MotorTransactionDefaultData {
    static var WithInsuranceConfirmationDemoViewModel = MotorTransactionModel(
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
                    body: NSAttributedString(string: "Du har oppgitt at du har forsikret denne bilen.")),
                detail: MotorTransactionStepContentModel(
                    body: NSAttributedString(string: "Om du vil bytte forsikring, kan du finne en ny som passer deg på våre sider."),
                    primaryButton: MotorTransactionButtonModel(
                        text: "Se bilforsikringer",
                        style: "FLAT",
                        action: "URL",
                        url: "https://www.google.com/search?q=contract+signed"))),

            MotorTransactionStepModel(
                state: .active,
                main: MotorTransactionStepContentModel(
                    title: "Betaling",
                    body: NSAttributedString(string: "Etter at du har forsikret bilen kan du starte betalingen"))),

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
