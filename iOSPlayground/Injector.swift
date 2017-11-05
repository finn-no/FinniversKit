import UIKit

extension UIViewController {
    #if DEBUG
    @objc func injected() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }

        viewDidLoad()
    }
    #endif
}

extension UIView {
    #if DEBUG
    @objc func injected() {
        for subview in subviews {
            subview.removeFromSuperview()
        }

        if let view = self as? LoginView {
            view.setup()
        }
    }
    #endif
}
