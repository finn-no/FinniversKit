//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var state: TransactionStepViewState { get }
    var title: String { get }
    var body: String? { get }
    var primaryButton: TransactionStepPrimaryButtonViewModel? { get }
    var detail: String? { get }
}

public protocol TransactionStepPrimaryButtonViewModel {
    var action: String? { get set }
    var text: String { get }
    var style: String { get set }
    var urlString: String? { get set }
    var fallbackUrlString: String? { get set }
}
