//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TransactionViewModel {
    var title: String { get set }
    var header: TransactionHeaderViewModel { get set }
    var alert: TransactionAlertViewModel { get set }
    var steps: [TransactionStepViewModel] { get }
}

public protocol TransactionHeaderViewModel {
    var adId: String { get set }
    var title: String { get set }
    var registrationNumber: String? { get set }
    var imageUrlString: String? { get set }
}

public protocol TransactionAlertViewModel {
    var title: String { get set }
    var message: String { get set }
    var imageUrlString: String? { get set }
}

public protocol TransactionStepViewModel {
    var state: TransactionStepViewState { get }
    var title: String { get }
    var body: String? { get }
    var button: TransactionStepButtonViewModel? { get }
    var detail: String? { get }
}

public protocol TransactionStepButtonViewModel {
    var action: String? { get set }
    var text: String { get }
    var style: String { get set }
    var urlString: String? { get set }
    var fallbackUrlString: String? { get set }
}
