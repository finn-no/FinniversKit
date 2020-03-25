//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionAlertViewModel {
    var title: String { get set }
    var body: String { get set }
    var imageIdentifier: String { get set }
}
