//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class MessageFormDemoPresenter {
    static let shared = MessageFormDemoPresenter()
}

extension MessageFormDemoPresenter: MessageFormBottomSheetDelegate {
    func messageFormBottomSheetDidDismiss(_ form: MessageFormBottomSheet) { }

    func messageFormBottomSheet(_ form: MessageFormBottomSheet, didFinishWithText text: String, telephone: String) {
        let alertController = UIAlertController(title: "Message sent!", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        form.present(alertController, animated: true)
    }
}
