import UIKit

public extension UIFont {

    public static var h1: UIFont {
        return UIFont.systemFont(ofSize: 36, weight: .medium)
    }

    public static var h2: UIFont {
        return UIFont.systemFont(ofSize: 28, weight: .light)
    }

    public static var h3: UIFont {
        return UIFont.systemFont(ofSize: 22.5, weight: .medium)
    }

    public static var h4: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    public static var h5: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    public static var body: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .light)
    }
    
    public static var detail: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .light)
    }
}
