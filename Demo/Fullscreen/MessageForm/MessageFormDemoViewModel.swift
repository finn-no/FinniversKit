//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoViewModel: MessageFormViewModel {
    let showTemplateToolbar = true

    let titleText = "Send melding"
    let sendButtonText = "Send"
    let cancelButtonText = "Avbryt"
    let transparencyText = "FINN.no forbeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post."
    let messageTemplates = [
        "Hei! Jeg er interessert, når passer det at jeg henter den?",
        "Hei! Jeg er interessert, kan du sende den?",
        "Hei! Jeg er interessert, er du villig til å diskutere prisen?",
    ]

    let replaceAlertTitle = "Erstatte innhold"
    let replaceAlertMessage = "Vil du erstatte det du allerede har skrevet?"
    let replaceAlertActionText = "Erstatt"
    let replaceAlertCancelText = "Avbryt"

    let cancelFormAlertTitle = "Forkast melding"
    let cancelFormAlertMessage = "Vil du forkaste meldingen du har skrevet?"
    let cancelFormAlertActionText = "Forkast"
    let cancelFormAlertCancelText = "Avbryt"
}
