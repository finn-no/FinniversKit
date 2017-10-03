import UIKit

public extension UIColor {
    private class func colorFromRGB(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
        return UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:1)
    }
    
    // Logo colors
    static let primaryBlue = colorFromRGB(0, 99, 251)
    static let primaryTurquoise = colorFromRGB(6, 190, 251)
    
    // Text colors
    static let licorice = colorFromRGB(71, 68, 69)
    static let stone = colorFromRGB(118, 118, 118)
    static let sardine = colorFromRGB(223, 228, 232)
    
    // Background colors
    static let ice = colorFromRGB(241, 249, 255)
    static let mint = colorFromRGB(204, 255, 236)
    static let salmon = colorFromRGB(255, 206, 215)
    static let milk = colorFromRGB(255, 255, 255)
    static let toothPaste = colorFromRGB(182, 240, 255)
    static let banana = colorFromRGB(255, 245, 200)
    
    // Detail colors
    static let pea = colorFromRGB(104, 226, 186)
    static let watermelon = colorFromRGB(255, 88, 68)
    static let cherry = colorFromRGB(218, 36, 0)
}
