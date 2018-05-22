//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ConsentTransparencyInfoViewModel {
    var mainHeaderText: String { get }
    var mainIntroText: String { get }
    var usageHeaderText: String { get }
    var usageIntro1Text: String { get }
    var usageIntro2Text: String { get }
    var usageBulletPointsText: NSAttributedString { get }
    var improveHeaderText: String { get }
    var improveIntroText: String { get }
    var improveButtonIntroWithSettingsText: String { get }
    var improveButtonIntroWithoutSettingsText: String { get }
    var settingsFinnButtonTitle: String { get }
    var privacyFinnButtonTitle: String { get }
    var usageSchibstedHeaderText: String { get }
    var usageSchibstedIntroText: String { get }
    var usageSchibstedBulletPointsText: NSAttributedString { get }
    var usageSchibstedButtonIntroWithSettingsText: String { get }
    var usageSchibstedButtonIntroWithoutSettingsText: String { get }
    var settingsSchibstedButtonTitle: String { get }
    var privacySchibstedButtonTitle: String { get }
}
