//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public protocol ConsentDetailDefinition {
    var text: String { get }
}

public protocol ConsentDetailPurpose {
    var heading: String { get }
    var description: String { get }
}

public protocol ConsentDetailViewModel {
    var definition: ConsentDetailDefinition { get }
    var purpose: ConsentDetailPurpose { get }
}
