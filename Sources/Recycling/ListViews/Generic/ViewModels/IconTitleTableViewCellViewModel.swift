//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol IconTitleTableViewCellViewModel: BasicTableViewCellViewModel {
    var icon: UIImage? { get }
    var iconTintColor: UIColor? { get }
    var hasChevron: Bool { get }
}
