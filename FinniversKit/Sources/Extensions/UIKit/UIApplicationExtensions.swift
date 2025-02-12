import UIKit

extension UIApplication {
    public var firstWindow: UIWindow? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.windows.filter { $0.isKeyWindow }.first
        }
        return nil
    }
}
