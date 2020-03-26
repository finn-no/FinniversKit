//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ConsentTransparencyInfoViewModel {
    var mainHeaderText: String { get }

    var finnHeaderText: String { get }
    var finnIntroText: String { get }
    var finnBulletPointsText: NSAttributedString { get }
    var finnButtonIntroWithSettingsText: String { get }
    var finnButtonIntroWithoutSettingsText: String { get }
    var finnSettingsButtonTitle: String { get }
    var finnPrivacyButtonTitle: String { get }

    var schibstedHeaderText: String { get }
    var schibstedIntroText: String { get }
    var schibstedBulletPointsText: NSAttributedString { get }
    var schibstedButtonIntroWithSettingsText: String { get }
    var schibstedButtonIntroWithoutSettingsText: String { get }
    var schibstedSettingsButtonTitle: String { get }
    var schibstedPrivacyButtonTitle: String { get }
}
