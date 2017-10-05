import UIKit

internal extension UIImage {

    convenience init?(frameworkImageNamed name: String) {
        self.init(named: name, in: .troika, compatibleWith: nil)
    }
}
