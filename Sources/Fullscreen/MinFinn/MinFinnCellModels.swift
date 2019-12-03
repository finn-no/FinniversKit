//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol MinFinnCellModel: BasicTableViewCellViewModel {}

extension MinFinnCellModel {
    public var subtitle: String? { nil }
    public var detailText: String? { nil }
}

public protocol MinFinnProfileCellModel: MinFinnCellModel {
    var image: UIImage? { get }
    var subtitle: String? { get }
    var showBadge: Bool { get }
}

extension MinFinnProfileCellModel {
    public var hasChevron: Bool { false }
}

public protocol MinFinnIconCellModel: IconTitleTableViewCellViewModel, MinFinnCellModel {}

extension MinFinnIconCellModel {
    public var iconTintColor: UIColor? { .licorice }
    public var hasChevron: Bool { true }
}
