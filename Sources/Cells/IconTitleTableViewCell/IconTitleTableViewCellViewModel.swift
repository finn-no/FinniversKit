//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap

public protocol IconTitleTableViewCellViewModel: BasicTableViewCellViewModel {
    var icon: UIImage? { get }
    var iconTintColor: UIColor? { get }
    var hasChevron: Bool { get }
}
