//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionWarningViewModel {
    var title: String { get set }
    var message: String { get set }
    var imageUrlString: String? { get set }
}
