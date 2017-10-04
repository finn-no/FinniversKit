import UIKit

public extension UIImage {

    convenience init?(frameworkImageNamed name: String) {
        self.init(named: name, in: .troika, compatibleWith: nil)
    }
}
