//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var state: TransactionStepViewState { get }
    var style: TransactionStepViewCustomStyle? { get }
    var main: TransactionStepContentViewModel? { get }
    var detail: TransactionStepContentViewModel? { get }
}

public protocol TransactionStepContentViewModel {
    var title: String? { get }
    var body: NSAttributedString? { get }
    var primaryButton: TransactionStepActionButtonViewModel? { get }
    /*
     For certain steps the attributed string assigned to body will contain a href element.
     The host app will remove the <a href> element and the nativeButton will be rendered with the necessary action/url.
     */
    var secondaryButton: TransactionStepActionButtonViewModel? { get }
}

public protocol TransactionStepActionButtonViewModel {
    var action: String? { get set }
    var text: String { get }
    var style: String { get set }
    var url: String? { get set }
    var fallbackUrl: String? { get set }
}
