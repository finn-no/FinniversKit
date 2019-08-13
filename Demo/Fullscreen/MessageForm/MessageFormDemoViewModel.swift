//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoViewModel: MessageFormViewModel {
    let showTemplateToolbar = true
    let showCustomizeButton = true
    let messageTemplateStore: MessageTemplateStoreProtocol? = DemoMessageTemplateStore()

    let titleText = "Send melding"
    let sendButtonText = "Send"
    var editButtonText = "Rediger"
    var doneButtonText = "Ferdig"
    var saveButtonText = "Lagre"
    let cancelButtonText = "Avbryt"
    var deleteActionText = "Slett"
    let transparencyText = "FINN.no forbeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post."
    let defaultMessageTemplates = [
        MessageFormTemplate(text: "Hei! Jeg er interessert, når passer det at jeg henter den?", id: "1"),
        MessageFormTemplate(text: "Hei! Jeg er interessert, kan du sende den?", id: "2"),
        MessageFormTemplate(text: "Hei! Jeg er interessert, er du villig til å diskutere prisen?", id: "3"),
    ]

    let replaceAlertTitle = "Erstatte innhold"
    let replaceAlertMessage = "Vil du erstatte det du allerede har skrevet?"
    let replaceAlertActionText = "Erstatt"
    let replaceAlertCancelText = "Avbryt"

    let cancelFormAlertTitle = "Forkast melding"
    let cancelFormAlertMessage = "Vil du forkaste meldingen du har skrevet?"
    let cancelFormAlertActionText = "Forkast"
    let cancelFormAlertCancelText = "Avbryt"

    var customTemplatesTitleText = "Dine meldingsmaler"
    var customTemplateEditText = "Endre meldingsmal"
    var customTemplateNewText = "Ny meldingsmal"
    var newCustomTemplatePromptText = "Legg til meldingsmal"
    var noCustomTemplatesText = "Du har ingen meldingsmaler"
}
