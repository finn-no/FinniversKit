//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol MinFinnCellModel: BasicTableViewCellViewModel {}

extension MinFinnCellModel {
    public var subtitle: String? { nil }
    public var detailText: String? { nil }
}

public protocol MinFinnProfileCellModel: MinFinnCellModel, IdentityViewModel {}

extension MinFinnProfileCellModel {
    public var title: String { "" }
    public var hasChevron: Bool { false }
    public var subtitle: String? { nil }
    public var description: String? { nil }
    public var displayMode: IdentityView.DisplayMode { .nonInteractible }
}

public protocol MinFinnIconCellModel: MinFinnCellModel, IconTitleTableViewCellViewModel {}

extension MinFinnIconCellModel {
    public var iconTintColor: UIColor? { .licorice }
    public var hasChevron: Bool { true }
}
