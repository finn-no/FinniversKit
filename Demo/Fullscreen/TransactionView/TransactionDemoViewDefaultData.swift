//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public struct TransactionModel: TransactionViewModel {
    public var title: String
    public var header: TransactionHeaderViewModel
    public var alert: TransactionAlertViewModel
    public var steps: [TransactionStepViewModel]
}

public struct TransactionHeaderModel: TransactionHeaderViewModel {
    public var adId: String
    public var title: String
    public var registrationNumber: String?
    public var imageUrlString: String?
}

public struct TransactionAlertModel: TransactionAlertViewModel {
    public var title: String
    public var message: String
    public var imageUrlString: String?
}

public struct TransactionStepModel: TransactionStepViewModel {
    public var state: TransactionStepViewState
    public var title: String
    public var body: String?
    public var button: TransactionStepButtonViewModel?
    public var detail: String?
}

public struct TransactionStepButtonModel: TransactionStepButtonViewModel {
    public var text: String
    public var style: String
    public var action: String?
    public var urlString: String?
    public var fallbackUrlString: String?
}

public struct TransactionDemoViewDefaultData {
    static var model = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imageUrlString: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        alert: TransactionAlertModel(
            title: "AlertTitle",
            message: "You have multiple contracts open",
            imageUrlString: nil),

        steps: [
            TransactionStepModel(
                state: .completed,
                title: "Annonsen er lagt ut",
                body: nil,
                button: TransactionStepButtonModel(
                    text: "Se annonsen",
                    style: "flat",
                    action: "see_ad",
                    fallbackUrlString: "www.finn.no/171529672"
                ),
                detail: nil),

            TransactionStepModel(
                state: .completed,
                title: "Kontrakt",
                body: "Begge har signert kontrakten.",
                button: TransactionStepButtonModel(
                    text: "Gå til kontrakt",
                    style: "flat",
                    urlString: "https://www.google.com/search?q=contract+signed"
                ),
                detail: nil),

            TransactionStepModel(
                state: .completed,
                title: "Betaling",
                body: "Kjøper betalte 1. februar 2020",
                button: nil,
                detail: "Utbeatlingen starter først når begge har bekreftet at overleveringen har skjedd."),

            TransactionStepModel(
                state: .active,
                title: "Overlevering",
                body: "<p>Du har bekreftet overleveringen.<br/>Venter på kjøper.</p><p>Dere må bekrefte før:<br/><strong>8. februar 2020.</strong></p><ol><li>Ved oppmøte registrerer dere først eierskiftet digitalt hos Statens vegvesen.</li><li>Deretter må <strong>begge</strong> bekrefte at overleveringen har skjedd, og at pengene kan utbetales.</li></ol>",
                button: TransactionStepButtonModel(
                    text: "Bekreft overlevering",
                    style: "call_to_action",
                    action: "url",
                    urlString: "https://www.vegvesen.no/"
                ),
                detail: "Hvis fristen går ut før dere har bekreftet, ta kontakt med Swiftcourt for å få pengene ut av hvelvet."),

            TransactionStepModel(
                state: .notStarted,
                title: "Gratulerer med salget!",
                body: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før».",
                button: nil,
                detail: "Det kan ta noen dager før pengene dukker opp på kontoen din.")
    ])
}
