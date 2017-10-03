import UIKit

public extension UIImage {

    convenience init?(frameworkImageNamed name: String) {
        self.init(named: name, in: Bundle(for: Troika.self), compatibleWith: nil)
    }
}
