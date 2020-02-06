//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

// MARK: - MinFinnCellModel
public protocol MinFinnCellModel: BasicTableViewCellViewModel {}

public extension MinFinnCellModel {
    var subtitle: String? { nil }
    var detailText: String? { nil }
    var hasChevron: Bool { false }
}

// MARK: - MinFinnProfileCellModel
public protocol MinFinnProfileCellModel: MinFinnCellModel, IdentityViewModel {
    var delegate: MinFinnProfileCellDelegate? { get }
}

public extension MinFinnProfileCellModel {
    var title: String { "" }
    var description: String? { nil }
    var displayMode: IdentityView.DisplayMode { .nonInteractible }
}

// MARK: - MinFinnVerifyCellModel
public protocol MinFinnVerifyCellModel: MinFinnCellModel {
    var text: String { get }
    var primaryButtonTitle: String { get }
    var secondaryButtonTitle: String { get }
    var delegate: MinFinnVerifyCellDelegate? { get }
}

// MARK: - MinFinnIconCellModel
public protocol MinFinnIconCellModel: MinFinnCellModel, IconTitleTableViewCellViewModel {}

public extension MinFinnIconCellModel {
    var iconTintColor: UIColor? { .iconPrimary }
    var hasChevron: Bool { true }
}
