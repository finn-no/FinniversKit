//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@objc extension UIColor {
    @objc public class var ice: UIColor {
        return UIColor(r: 241, g: 249, b: 255)!
    }

    @objc public class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }

    @objc public class var licorice: UIColor {
        return UIColor(r: 71, g: 68, b: 69)!
    }

    @objc public class var primaryBlue: UIColor {
        return UIColor(r: 0, g: 99, b: 251)!
    }

    @objc public class var secondaryBlue: UIColor {
        return UIColor(r: 6, g: 190, b: 251)!
    }

    @objc public class var stone: UIColor {
        return UIColor(r: 118, g: 118, b: 118)!
    }

    @objc public class var sardine: UIColor {
        return UIColor(r: 195, g: 204, b: 217)!
    }

    @objc public class var salmon: UIColor {
        return UIColor(r: 255, g: 206, b: 215)!
    }

    @objc public class var mint: UIColor {
        return UIColor(r: 204, g: 255, b: 236)!
    }

    @objc public class var toothPaste: UIColor {
        return UIColor(r: 182, g: 240, b: 255)!
    }

    @objc public class var banana: UIColor {
        return UIColor(r: 255, g: 245, b: 200)!
    }

    @objc public class var cherry: UIColor {
        return UIColor(r: 218, g: 36, b: 0)!
    }

    @objc public class var watermelon: UIColor {
        return UIColor(r: 255, g: 88, b: 68)!
    }

    @objc public class var pea: UIColor {
        return UIColor(r: 104, g: 226, b: 184)!
    }

    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}

extension CGColor {
    public class var ice: CGColor {
        return UIColor.ice.cgColor
    }

    public class var milk: CGColor {
        return UIColor.milk.cgColor
    }

    public class var licorice: CGColor {
        return UIColor.licorice.cgColor
    }

    public class var primaryBlue: CGColor {
        return UIColor.primaryBlue.cgColor
    }

    public class var secondaryBlue: CGColor {
        return UIColor.secondaryBlue.cgColor
    }

    public class var stone: CGColor {
        return UIColor.stone.cgColor
    }

    public class var sardine: CGColor {
        return UIColor.sardine.cgColor
    }

    public class var salmon: CGColor {
        return UIColor.salmon.cgColor
    }

    public class var mint: CGColor {
        return UIColor.mint.cgColor
    }

    public class var toothPaste: CGColor {
        return UIColor.toothPaste.cgColor
    }

    public class var banana: CGColor {
        return UIColor.banana.cgColor
    }

    public class var cherry: CGColor {
        return UIColor.cherry.cgColor
    }

    public class var watermelon: CGColor {
        return UIColor.watermelon.cgColor
    }

    public class var pea: CGColor {
        return UIColor.pea.cgColor
    }
}

// MARK: - Button

extension UIColor {
    @objc public class var callToActionButtonHighlightedBodyColor: UIColor {
        return primaryBlue.withAlphaComponent(0.8)
    }

    @objc public class var destructiveButtonHighlightedBodyColor: UIColor {
        return cherry.withAlphaComponent(0.8)
    }

    @objc public class var defaultButtonHighlightedBodyColor: UIColor {
        return UIColor(r: 241, g: 249, b: 255)!
    }

    @objc public class var linkButtonHighlightedTextColor: UIColor {
        return primaryBlue.withAlphaComponent(0.8)
    }

    @objc public class var flatButtonHighlightedTextColor: UIColor {
        return primaryBlue.withAlphaComponent(0.8)
    }
}

extension CGColor {
    public class var callToActionButtonHighlightedBodyColor: CGColor {
        return UIColor.callToActionButtonHighlightedBodyColor.cgColor
    }

    public class var destructiveButtonHighlightedBodyColor: CGColor {
        return UIColor.destructiveButtonHighlightedBodyColor.cgColor
    }

    public class var defaultButtonHighlightedBodyColor: CGColor {
        return UIColor.defaultButtonHighlightedBodyColor.cgColor
    }

    public class var linkButtonHighlightedTextColor: CGColor {
        return UIColor.linkButtonHighlightedTextColor.cgColor
    }

    public class var flatButtonHighlightedTextColor: CGColor {
        return UIColor.flatButtonHighlightedTextColor.cgColor
    }
}
