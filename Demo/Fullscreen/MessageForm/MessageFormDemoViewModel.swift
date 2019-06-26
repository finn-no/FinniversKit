//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoViewModel: MessageFormViewModel {
    let showTemplateToolbar = true
    let showTemplateCustomizationButton = false

    let titleText = "Send melding"
    let sendButtonText = "Send"
    let cancelButtonText = "Avbryt"
    let transparencyText = "FINN.no forbeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post."
    let messageTemplates = [
        "Det ser ut som du prøver å selge noe på FINN 📎",
        "Hei! Jeg er interessert hvis denne fortsatt er tilgjengelig 🙂",
        "Hei! Er prisen diskuterbar? 💰",
        "Hei! Jeg kan hente denne i morgen hvis det passer for deg 🚛"
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
