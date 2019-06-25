//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoPresenter {
    static let shared = MessageFormDemoPresenter()
}

extension MessageFormDemoPresenter: MessageFormBottomSheetDelegate {
    func messageFormBottomSheetDidCancel(_ form: MessageFormBottomSheet) {
        form.state = .dismissed
    }

    func messageFormBottomSheet(_ form: MessageFormBottomSheet, didFinishWithText text: String, templateState: MessageFormTemplateState) {
        let alertController = UIAlertController(title: "Message sent!", message: "templateState: \(templateState)\n\n\(text)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        form.present(alertController, animated: true)
    }
}
