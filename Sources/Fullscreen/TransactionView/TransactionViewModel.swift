//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionViewModel {
    var title: String { get set }
    var header: TransactionHeaderViewModel { get set }
    var warning: TransactionWarningViewModel { get set }
    var steps: [TransactionStepViewModel] { get }
}
