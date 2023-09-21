import UIKit

extension Collection where Element == UIScene {
    public var keyWindow: UIWindow? {
        self.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
