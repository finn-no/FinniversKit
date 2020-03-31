//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionStepContentViewModel {
    var title: String? { get }
    var body: NSAttributedString? { get }
    /*
     For certain steps the attributed string assigned to body will contain a href element.
     The host app will remove the <a href> element and the nativeButton will be rendered above the primaryButton.
     */
    var nativeButton: TransactionStepContentActionButtonViewModel? { get }
    var primaryButton: TransactionStepContentActionButtonViewModel? { get }
}
