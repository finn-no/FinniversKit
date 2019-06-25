//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoViewModel: MessageFormViewModel {
    let showTemplateToolbar: Bool
    let showTemplateCustomizationButton: Bool

    let titleText: String
    let sendButtonText: String
    let cancelButtonText: String
    let transparencyText: String
    let messageTemplates: [String]

    let replaceAlertTitle: String
    let replaceAlertMessage: String
    let replaceAlertReplaceActionText: String
    let replaceAlertCancelActionText: String

    init(showTemplateToolbar: Bool,
         showTemplateCustomizationButton: Bool,
         titleText: String,
         sendButtonText: String,
         cancelButtonText: String,
         transparencyText: String,
         messageTemplates: [String],
         replaceAlertTitle: String,
         replaceAlertMessage: String,
         replaceAlertReplaceActionText: String,
         replaceAlertCancelActionText: String
    ) {
        self.showTemplateToolbar = showTemplateToolbar
        self.showTemplateCustomizationButton = showTemplateCustomizationButton
        self.titleText = titleText
        self.sendButtonText = sendButtonText
        self.cancelButtonText = cancelButtonText
        self.transparencyText = transparencyText
        self.messageTemplates = messageTemplates
        self.replaceAlertTitle = replaceAlertTitle
        self.replaceAlertMessage = replaceAlertMessage
        self.replaceAlertReplaceActionText = replaceAlertReplaceActionText
        self.replaceAlertCancelActionText = replaceAlertCancelActionText
    }
}

extension MessageFormDemoViewModel {
    static var `default`: MessageFormDemoViewModel {
        return MessageFormDemoViewModel(showTemplateToolbar: true,
                                        showTemplateCustomizationButton: false,
                                        titleText: "Send melding",
                                        sendButtonText: "Send",
                                        cancelButtonText: "Avbryt",
                                        transparencyText: "FINN.no forbeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post.",
                                        messageTemplates: [
                                            "Det ser ut som du prøver å selge noe på FINN 📎",
                                            "Hei! Jeg er interessert hvis denne fortsatt er tilgjengelig 🙂",
                                            "Hei! Er prisen diskuterbar? 💰",
                                            "Hei! Jeg kan hente denne i morgen hvis det passer for deg 🚛"
                                        ],
                                        replaceAlertTitle: "Erstatte innhold",
                                        replaceAlertMessage: "Vil du erstatte det du allerede har skrevet?",
                                        replaceAlertReplaceActionText: "Erstatt",
                                        replaceAlertCancelActionText: "Avbryt"
        )
    }
}
