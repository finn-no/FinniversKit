//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol MotorTransactionHeaderViewModel {
    var adId: String { get set }
    var title: String? { get set }
    var registrationNumber: String? { get set }
    var imagePath: String? { get set }
}
