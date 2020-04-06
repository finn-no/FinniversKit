//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionStepContentViewModel {
    var title: String? { get }
    /*
     If body contains a link (<a href>), the backend will assign the same content to nativeBody, but without the (<a href>) link.
     Instead the nativeButton will also be present in the payload with the action and link as an replacement.

     This is to avoid having the client render both a link and a nativeButton.
    */
    var body: NSAttributedString? { get }
    var nativeBody: NSAttributedString? { get }
    var nativeButton: TransactionActionButtonViewModel? { get }
    var primaryButton: TransactionActionButtonViewModel? { get }
}
