//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        size(withConstrainedRect: CGSize(width: width, height: .greatestFiniteMagnitude), font: font).height
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        size(withConstrainedRect: CGSize(width: .greatestFiniteMagnitude, height: height), font: font).width
    }

    func size(withConstrainedRect rect: CGSize, font: UIFont) -> CGSize {
        let boundingBox = (self as NSString).boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return CGSize(
            width: ceil(boundingBox.width),
            height: ceil(boundingBox.height)
        )
    }

    func attributedStringWithLineSpacing(_ space: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space

        let attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))

        return attrString
    }

    func asAttributedString(attributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        NSAttributedString(string: self, attributes: attributes)
    }

    // Ignores emojies symbols accrodingly to https://www.ascii-code.com
    func withoutEmoji() -> String {
        let filteredScalars = unicodeScalars.filter { !$0.properties.isEmojiPresentation }
        return String(filteredScalars)
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let value = self else {
            return true
        }
        return value.isEmpty
    }
}
