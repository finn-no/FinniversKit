//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol BannerTransparencyViewModel {
    var headerText: String { get }

    var adsSettingsTitle: String { get }
    var adsSettingsText: String { get }
    var adsSettingsButtonTitle: String { get }

    var readMoreTitle: String { get }
    var readMoreText: String { get }
    var readMoreButtonTitle: String { get }
}
