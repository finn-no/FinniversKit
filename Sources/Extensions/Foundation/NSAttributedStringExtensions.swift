//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    static func makeBulletPointFrom(stringList: [String], font: UIFont, bullet: String = "\u{2022}", indentation: CGFloat = .mediumLargeSpacing, lineSpacing: CGFloat = .verySmallSpacing, paragraphSpacing: CGFloat = .mediumSpacing, textColor: UIColor = .licorice, bulletColor: UIColor = .licorice) -> NSAttributedString {
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation

        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)"
            let attributedString = NSMutableAttributedString(string: formattedString)
            let lineShift = "\n"
            let attributedLineShift = NSMutableAttributedString(string: lineShift)

            let attributeRange = NSMakeRange(0, attributedString.length)
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: attributeRange)
            attributedString.addAttributes(textAttributes, range: attributeRange)

            let nsString: NSString = NSString(string: formattedString)
            let rangeForBullet: NSRange = nsString.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)

            if let lastString = stringList.last, !string.isEqual(lastString) {
                bulletList.append(attributedLineShift)
            }
        }
        return bulletList
    }
}
