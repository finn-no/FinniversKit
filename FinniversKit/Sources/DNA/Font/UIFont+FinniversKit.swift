//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

@objc extension UIFont {
    /// Font Medium/Bold with a size of 34 scaled for UIFontTextStyle.largeTitle
    ///
    /// ## Usage:
    /// - It should only be used one T1 and it should be the first text element that catches the users attention.
    /// - It shall give the user an overview of which page he or she is located.
    /// - This always has the weight Medium.
    public static var title1: UIFont {
        Warp.Typography.title1.uiFont
    }

    /// Font Medium/Bold with a size of 28 scaled for UIFontTextStyle.title1
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    public static var title2: UIFont {
        Warp.Typography.title2.uiFont
    }

    /// Font Medium/Bold with a size of 22 scaled for UIFontTextStyle.title2
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Light.
    public static var title3: UIFont {
        Warp.Typography.title3.uiFont
    }

    /// Font Medium/Bold with a size of 16 scaled for UIFontTextStyle.callout
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded (Medium) to differenciate them.
    public static var bodyStrong: UIFont {
        Warp.Typography.title4.uiFont
    }

    /// Font Light/Regular with a size of 16 scaled for UIFontTextStyle.body
    ///
    /// ## Usage:
    /// - Regular text below titles is called body text and is weighted Medium.
    public static var body: UIFont {
        Warp.Typography.body.uiFont
    }

    /// Font Light/Regular with a size of 14 scaled for UIFontTextStyle.footnote
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - This is slightly smaller than body text. Weighted Light.
    public static var caption: UIFont {
        Warp.Typography.caption.uiFont
    }

    /// Font Medium/Bold with a size of 14 scaled for UIFontTextStyle.footnote
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text. Weighted Medium.
    public static var captionStrong: UIFont {
        Warp.Typography.captionStrong.uiFont
    }

    /// Font Medium/Bold with a size of 12 scaled for UIFontTextStyle.caption1
    ///
    /// ## Usage:
    /// - Used for small, bold headlines.
    public static var detailStrong: UIFont {
        Warp.Typography.detailStrong.uiFont
    }

    /// Font Light/Regular with a size of 12 scaled for UIFontTextStyle.caption1
    ///
    /// ## Usage:
    /// - Less important information can be shown as detail text, not for long sentences.
    /// - This is slightly smaller than body text. Weighted Regular.
    /// - The color Stone is prefered in most cases with white background.
    /// - For colored background such as ribbons, the color should be Licorice.
    public static var detail: UIFont {
        Warp.Typography.detail.uiFont
    }
}
