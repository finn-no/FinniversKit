//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SelectionOptionModel {
    var identifier: String { get }
    var title: String { get }
    var icon: UIImage { get }
}
