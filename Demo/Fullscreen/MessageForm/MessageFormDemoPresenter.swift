//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoPresenter {
    static let shared = MessageFormDemoPresenter()
}

extension MessageFormDemoPresenter: MessageFormBottomSheetDelegate {
    func messageFormBottomSheetDidDismiss(_ form: MessageFormBottomSheet) { }

    func messageFormBottomSheet(_ form: MessageFormBottomSheet, didFinishWithText text: String, templateState: MessageFormTemplateState, template: MessageFormTemplate?) {
        var templateString = ""
        if let template = template {
            let id = template.id ?? "<nil>"
            templateString = "\ntemplate ID: \(id)\nuserDefined: \(template.isUserDefined)\n"
        }

        let alertController = UIAlertController(title: "Message sent!", message: "templateState: \(templateState)\(templateString)\n\n\(text)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        form.present(alertController, animated: true)
    }
}
