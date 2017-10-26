//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc public class var ice: UIColor {
        return UIColor(r: 241, g: 249, b: 255)!
    }

    @nonobjc public class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }

    @nonobjc public class var licorice: UIColor {
        return UIColor(r: 71, g: 68, b: 69)!
    }

    @nonobjc public class var primaryBlue: UIColor {
        return UIColor(r: 0, g: 99, b: 251)!
    }

    @nonobjc public class var secondaryBlue: UIColor {
        return UIColor(r: 6, g: 190, b: 251)!
    }

    @nonobjc public class var stone: UIColor {
        return UIColor(r: 118, g: 118, b: 118)!
    }

    @nonobjc public class var sardine: UIColor {
        return UIColor(r: 223, g: 228, b: 232)!
    }

    @nonobjc public class var salmon: UIColor {
        return UIColor(r: 255, g: 206, b: 215)!
    }

    @nonobjc public class var mint: UIColor {
        return UIColor(r: 204, g: 255, b: 236)!
    }

    @nonobjc public class var toothPaste: UIColor {
        return UIColor(r: 182, g: 240, b: 255)!
    }

    @nonobjc public class var banana: UIColor {
        return UIColor(r: 255, g: 245, b: 200)!
    }

    @nonobjc public class var cherry: UIColor {
        return UIColor(r: 218, g: 36, b: 0)!
    }

    @nonobjc public class var watermelon: UIColor {
        return UIColor(r: 255, g: 88, b: 68)!
    }

    @nonobjc public class var pea: UIColor {
        return UIColor(r: 104, g: 226, b: 184)!
    }

    private convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
