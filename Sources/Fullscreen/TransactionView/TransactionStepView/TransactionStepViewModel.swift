//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var state: TransactionStepViewState { get }
    var title: String { get }
    var body: NSAttributedString? { get }
    var primaryButton: TransactionStepActionButtonViewModel? { get }
    var secondaryButton: TransactionStepActionButtonViewModel? { get }
    var detail: String? { get }
}

public protocol TransactionStepActionButtonViewModel {
    var action: String? { get set }
    var text: String { get }
    var style: String { get set }
    var url: String? { get set }
    var fallbackUrl: String? { get set }
}
