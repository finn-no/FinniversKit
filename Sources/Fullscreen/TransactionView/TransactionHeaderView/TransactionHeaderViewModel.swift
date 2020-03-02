//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionHeaderViewModel {
    var adId: String { get set }
    var title: String { get set }
    var registrationNumber: String? { get set }
    var imageUrlString: String? { get set }
}
