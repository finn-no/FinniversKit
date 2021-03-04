//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MotorTransactionButtonViewModel {
    var text: String { get set }
    var style: String? { get set }
    var disabled: Bool? { get set }
    var action: String? { get set }
    var url: String? { get set }
    var fallbackUrl: String? { get set }

    init(text: String, style: String?, disabled: Bool?, action: String?, url: String?, fallbackUrl: String?)
}
