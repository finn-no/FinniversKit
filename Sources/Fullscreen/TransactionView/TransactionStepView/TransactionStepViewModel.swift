//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var state: TransactionState { get }
    var title: String { get }
    var body: String? { get }
    var buttonText: String? { get }
    var detail: String? { get }
}

public struct TransactionStepModel: TransactionStepViewModel {
    public var state: TransactionState
    public var title: String
    public var body: String?
    public var buttonText: String?
    public var detail: String?
}
