import UIKit

class NavigationController: UINavigationController {
    private var hairlineView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        updateColors(for: traitCollection, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange), name: .didChangeUserInterfaceStyle, object: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            #if swift(>=5.1)
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                userInterfaceStyleDidChange()
            }
            #endif
        }
    }

    @objc func userInterfaceStyleDidChange() {
        updateColors(for: traitCollection, animated: true)
    }

    func updateColors(for traitCollection: UITraitCollection, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            let separatorColor: UIColor = .sardine //DARK
            let barTintColor: UIColor = .bgPrimary
            let tintColor: UIColor = .textAction
            let barStyle: UIBarStyle = .default //DARK

            self.setBottomBorderColor(navigationBar: self.navigationBar, color: separatorColor, height: 0.5)
            self.navigationBar.barTintColor = barTintColor
            self.navigationBar.tintColor = tintColor
            self.navigationBar.barStyle = barStyle
            self.navigationBar.layoutIfNeeded()
        }
    }

    func setBottomBorderColor(navigationBar: UINavigationBar, color: UIColor, height: CGFloat) {
        if hairlineView == nil {
            let bottomBorderRect = CGRect(x: 0, y: navigationBar.frame.height, width: navigationBar.frame.width, height: height)
            let view = UIView(frame: bottomBorderRect)
            navigationBar.addSubview(view)
            hairlineView = view
        }

        hairlineView?.backgroundColor = color
    }
}
