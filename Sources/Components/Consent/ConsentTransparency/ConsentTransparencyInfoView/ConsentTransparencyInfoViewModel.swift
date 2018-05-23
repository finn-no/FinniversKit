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
    var usageBulletPointsText: [String] { get }
    var improveHeaderText: String { get }
    var improveIntroText: String { get }
    var improveButtonIntroWithSettingsText: String { get }
    var improveButtonIntroWithoutSettingsText: String { get }
    var settingsFinnButtonTitle: String { get }
    var privacyFinnButtonTitle: String { get }
    var usageSchibstedHeaderText: String { get }
    var usageSchibstedIntroText: String { get }
    var usageSchibstedBulletPointsText: [String] { get }
    var usageSchibstedButtonIntroWithSettingsText: String { get }
    var usageSchibstedButtonIntroWithoutSettingsText: String { get }
    var settingsSchibstedButtonTitle: String { get }
    var privacySchibstedButtonTitle: String { get }
}

extension Array where Element == String {
    func asBulletPoints() -> NSAttributedString {
        return NSAttributedString.makeBulletPointFrom(stringList: self, font: .body, bullet: "\u{2022}", indentation: .mediumLargeSpacing, lineSpacing: .verySmallSpacing, paragraphSpacing: .mediumSpacing, textColor: .licorice, bulletColor: .licorice)
    }
}
