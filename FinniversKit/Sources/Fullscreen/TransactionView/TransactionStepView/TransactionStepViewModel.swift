//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var state: TransactionStepViewState { get }
    var style: TransactionStepView.CustomStyle? { get }
    var main: TransactionStepContentViewModel? { get }
    var detail: TransactionStepContentViewModel? { get }
}
