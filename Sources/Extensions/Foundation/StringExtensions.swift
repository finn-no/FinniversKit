//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func multiLineWidth(withConstrainedHeight height: CGFloat, font: UIFont, minimumWidth: CGFloat) -> CGFloat {
        /// Courtesy of Stack Overflow user MSimic: https://stackoverflow.com/a/54114620
        var textWidth: CGFloat = minimumWidth
        let incrementWidth: CGFloat = minimumWidth * 0.1
        var textHeight: CGFloat = self.height(withConstrainedWidth: textWidth, font: font)

        // Increase width by 10% of minimumTextWrapWidth until minimum width found that makes the text fit within the specified height
        // Safety/failsafe: run for at most 100 iterations
        var iterations = 0

        while textHeight > height, iterations <= 100 {
            textWidth += incrementWidth
            textHeight = self.height(withConstrainedWidth: textWidth, font: font)
            iterations += 1
        }

        return ceil(textWidth)
    }

    func attributedStringWithLineSpacing(_ space: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space

        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))

        return attrString
    }
}
