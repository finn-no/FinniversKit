//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoViewModel: MessageFormViewModel {
    let titleText = "Send melding"
    let sendButtonText = "Send"
    var editButtonText = "Rediger"
    var doneButtonText = "Ferdig"
    var saveButtonText = "Lagre"
    let cancelButtonText = "Avbryt"
    var deleteActionText = "Slett"
    let transparencyText = "FINN.no forbeholder seg retten til å kontrollere meldinger og stoppe useriøs e-post."
    var legalText: String? = "Meldingen vil bli sendt som e-post til annonsøren, med din e-postadresse som avsender. Les mer om <a href=\"https://hjelpesenter.finn.no/hc/no/articles/22619166557330-Brukervilkår\">brukervilkår for FINN</a>."
    let disclaimerText = "FINN.no forbeholder seg retten til å kontrollere og stoppe meldinger"

    let messageText = "Melding"
    let messageHint = "Skriv melding..."
    let telephoneText = "Telefonnummer"
    let telephoneHint = "Ditt telefonnummer"

    let cancelFormAlertTitle = "Forkast melding"
    let cancelFormAlertMessage = "Vil du forkaste meldingen du har skrevet?"
    let cancelFormAlertActionText = "Forkast"
    let cancelFormAlertCancelText = "Avbryt"
}
