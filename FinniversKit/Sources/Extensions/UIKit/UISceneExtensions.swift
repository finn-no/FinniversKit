import UIKit

extension Set<UIScene> {
    public var keyWindow: UIWindow? {
        self.compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
