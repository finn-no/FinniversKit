import UIKit

public extension UIColor {
    /// Base initializer, it creates an instance of `UIColor` using an HEX string.
    ///
    /// - Parameter hex: The base HEX string to create the color.
    public convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols

        var hexInt: UInt32 = 0
        if (scanner.scanHexInt32(&hexInt)) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }

    /// Convenience initializers for RGB colors.
    ///
    /// - Parameters:
    ///   - red: The red part, ranging from 0 to 255.
    ///   - green: The green part, ranging from 0 to 255.
    ///   - blue: The blue part, ranging from 0 to 255.
    ///   - alpha: The alpha part, ranging from 0 to 100.
    public convenience init(r red: Double, g green: Double, b blue: Double, a alpha: Double = 100) {
        self.init(red: CGFloat(red)/CGFloat(255.0), green: CGFloat(green)/CGFloat(255.0), blue: CGFloat(blue)/CGFloat(255.0), alpha: CGFloat(alpha)/CGFloat(100.0))
    }

    /// Compares if two colors are equal.
    ///
    /// - Parameter color: A UIColor to compare.
    /// - Returns: A boolean, true if same (or very similar) and false otherwise.
    public func isEqual(to color: UIColor) -> Bool {
        let currentRGBA = self.RGBA
        let comparedRGBA = color.RGBA

        return self.compareColorComponents(a: currentRGBA[0], b: comparedRGBA[0]) &&
            self.compareColorComponents(a: currentRGBA[1], b: comparedRGBA[1]) &&
            self.compareColorComponents(a: currentRGBA[2], b: comparedRGBA[2]) &&
            self.compareColorComponents(a: currentRGBA[3], b: comparedRGBA[3])
    }


    /// Get the red, green, blue and alpha values.
    private var RGBA: [CGFloat] {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b, a]
    }

    private func compareColorComponents(a: CGFloat, b: CGFloat) -> Bool {
        return abs(b - a) <= 0
    }
}
