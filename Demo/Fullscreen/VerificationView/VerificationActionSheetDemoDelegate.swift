//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class VerificationActionSheetDemoDelegate: VerificationActionSheetDelegate {
    static let shared = VerificationActionSheetDemoDelegate()

    func didTapVerificationActionSheetButton(_ sheet: VerificationActionSheet) {
        sheet.dismiss(animated: false, completion: nil)
    }
}
