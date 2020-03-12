//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionAlertViewModel {
    var title: String { get set }
    var message: String { get set }
    var imageUrl: String? { get set }
}
