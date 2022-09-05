//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@objc public extension UIFont {
    /// ## Usage:
    /// - It should only be used one T1 and it should be the first text element that catches the users attention.
    /// - It shall give the user an overview of which page he or she is located.
    class var title1: UIFont {
        Config.fontProvider.title1
    }

    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    class var title2: UIFont {
        Config.fontProvider.title2
    }

    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    class var title2Strong: UIFont {
        Config.fontProvider.title2Strong
    }

    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    class var title3Strong: UIFont {
        Config.fontProvider.title3Strong
    }

    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    class var title3: UIFont {
        Config.fontProvider.title3
    }

    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded to differenciate them.
    class var bodyStrong: UIFont {
        Config.fontProvider.bodyStrong
    }

    /// ## Usage:
    /// - This have the same size as the body text, but is always semibolded (Regular) to differenciate them.
    class var bodyRegular: UIFont {
        Config.fontProvider.bodyRegular
    }

    /// ## Usage:
    /// - Regular text below titles is called body text
    class var body: UIFont {
        Config.fontProvider.body
    }

    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - This is slightly smaller than body text.
    class var caption: UIFont {
        Config.fontProvider.caption
    }

    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text.
    class var captionStrong: UIFont {
        Config.fontProvider.captionStrong
    }

    /// ## Usage:
    /// - Used for small, bold headlines.
    class var detailStrong: UIFont {
        Config.fontProvider.detailStrong
    }

    /// ## Usage:
    /// - Less important information can be shown as detail text, not for long sentences.
    /// - This is slightly smaller than body text.
    class var detail: UIFont {
        Config.fontProvider.detail
    }

    func scaledFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        if Config.isDynamicTypeEnabled {
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: self)
        } else {
            return self
        }
    }
}

public extension UIFont {
    class func font(ofSize size: CGFloat, weight: FontWeight, textStyle: UIFont.TextStyle) -> UIFont {
        Config.fontProvider.font(ofSize: size, weight: weight).scaledFont(forTextStyle: textStyle)
    }
}

// MARK: - Deprecated font names

extension UIFont {
    @available(*, deprecated, message: "Use bodyStrong instead.")
    public class var title4: UIFont {
        return bodyStrong
    }

    @available(*, deprecated, message: "Use detailStrong instead.")
    public class var title5: UIFont {
        return detailStrong
    }

    @available(*, deprecated, message: "Use captionStrong instead.")
    public class var captionHeavy: UIFont {
        return captionStrong
    }
}
