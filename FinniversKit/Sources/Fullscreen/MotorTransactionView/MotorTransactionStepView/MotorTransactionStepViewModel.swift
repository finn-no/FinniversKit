//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol MotorTransactionStepViewModel {
    var state: MotorTransactionStepViewState { get }
    var style: MotorTransactionStepView.CustomStyle? { get }
    var main: MotorTransactionStepContentViewModel? { get }
    var detail: MotorTransactionStepContentViewModel? { get }
}
