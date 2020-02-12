//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var transactionStep: Int { get }
    var title: String { get }
    var detail: String? { get }
    var buttonText: String? { get }
    var infoText: String? { get }
}

public struct TransactionStepModel: TransactionStepViewModel {
    public var transactionStep: Int
    public var title: String
    public var detail: String?
    public var buttonText: String?
    public var infoText: String?
}
