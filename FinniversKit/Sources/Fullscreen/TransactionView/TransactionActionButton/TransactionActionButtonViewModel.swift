//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol TransactionActionButtonViewModel {
    var action: String? { get set }
    var text: String { get }
    var style: String { get set }
    var url: String? { get set }
    var fallbackUrl: String? { get set }
}
