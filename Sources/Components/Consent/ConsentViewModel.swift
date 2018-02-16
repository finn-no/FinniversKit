//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ConsentViewModel {
    var yesButtonTitle: String { get }
    var noButtonTitle: String { get }
    var cancelButtonTitle: String { get }
    var descriptionTitle: String { get }
    var descriptionIntroText: String { get }
    var descriptionText: String { get }
    var bulletPoints: [String] { get }

    func formatedBulletPoints(with font: UIFont) -> NSAttributedString
}

public extension ConsentViewModel {
    func formatedBulletPoints(with font: UIFont) -> NSAttributedString {
        return NSAttributedString.makeBulletPointFrom(stringList: bulletPoints, font: font, bullet: "\u{2022}", indentation: .mediumLargeSpacing, lineSpacing: .verySmallSpacing, paragraphSpacing: .mediumSpacing, textColor: .licorice, bulletColor: .secondaryBlue)
    }
}
