//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TransactionStepViewModel {
    var title: String { get }
    var subtitle: String? { get }
    var buttonText: String? { get }
    var detail: String? { get }
}

public struct TransactionStepModel: TransactionStepViewModel {
    public var title: String
    public var subtitle: String?
    public var buttonText: String?
    public var detail: String?
}
