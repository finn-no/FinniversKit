//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AddressViewModel {
    var mapTypes: [String] { get }
    var selectedMapMode: Int { get }
    var address: String { get }
    var postalCode: String { get }
    var secondaryActionTitle: String { get }
    var primaryActionTitle: String { get }
}
