//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    static func bulletPoints(
        from stringList: [String],
        font: UIFont,
        bullet: String = "\u{2022}",
        indentation: CGFloat = 24,
        paragraphSpacing: CGFloat = 6,
        textColor: UIColor = .textPrimary,
        bulletColor: UIColor = .textPrimary
    ) -> NSAttributedString {
        let bulletList = NSMutableAttributedString()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        let indentation = indentation / 2
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation * 3

        let bulletAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: bulletColor]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]

        for string in stringList {
            let formattedString = "\t\(bullet)\t\t\(string)"
            let attributedString = NSMutableAttributedString(string: formattedString)
            let lineShift = "\n"
            let attributedLineShift = NSMutableAttributedString(string: lineShift)

            let attributeRange = NSRange(location: 0, length: attributedString.length)
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

public extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        leftCopy.append(right)
        return leftCopy
    }
    static func + (left: NSAttributedString, right: String) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        let rightAttr = NSMutableAttributedString(string: right)
        leftCopy.append(rightAttr)
        return leftCopy
    }
    static func + (left: String, right: NSAttributedString) -> NSAttributedString {
        let leftAttr = NSMutableAttributedString(string: left)
        leftAttr.append(right)
        return leftAttr
    }
}

public extension NSMutableAttributedString {
    static func += (left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
        let rightAttr = NSMutableAttributedString(string: right)
        left.append(rightAttr)
        return left
    }
    static func += (left: NSMutableAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
        left.append(right)
        return left
    }
}
