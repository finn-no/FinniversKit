//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol MotorTransactionViewModel {
    var title: String { get set }
    var header: MotorTransactionHeaderViewModel? { get set }
    var alert: MotorTransactionAlertViewModel? { get set }
    var steps: [MotorTransactionStepViewModel] { get }
}
