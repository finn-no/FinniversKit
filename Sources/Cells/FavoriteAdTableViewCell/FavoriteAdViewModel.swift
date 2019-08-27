//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdViewModel {
    var addressText: String? { get }
    var titleText: String { get }
    var titleColor: UIColor { get }
    var descriptionPrimaryText: String? { get }
    var descriptionSecondaryText: String? { get }
    var imagePath: String? { get }
    var ribbonStyle: RibbonView.Style { get }
    var ribbonTitle: String { get }
}
