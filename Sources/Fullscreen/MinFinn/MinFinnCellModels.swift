//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol MinFinnCellModel {}

public protocol MinFinnProfileCellModel: MinFinnCellModel, IdentityViewModel {}

extension MinFinnProfileCellModel {
    public var title: String { "" }
    public var hasChevron: Bool { false }
    public var subtitle: String? { nil }
    public var description: String? { nil }
    public var displayMode: IdentityView.DisplayMode { .nonInteractible }
}

public protocol MinFinnVerifyCellModel: MinFinnCellModel {
    var title: String { get }
    var buttonTitle: String { get }
}

public protocol MinFinnIconCellModel: MinFinnCellModel, IconTitleTableViewCellViewModel {}

extension MinFinnIconCellModel {
    public var subtitle: String? { nil }
    public var detailText: String? { nil }
    public var iconTintColor: UIColor? { .licorice }
}
