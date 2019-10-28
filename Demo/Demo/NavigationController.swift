import UIKit

class NavigationController: UINavigationController {
    private var hairlineView: UIView?
    var hairlineIsHidden: Bool = false {
        didSet {
            hairlineView?.isHidden = hairlineIsHidden
            if hairlineIsHidden {
                navigationBar.shadowImage = UIImage()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        updateColors(animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange), name: .didChangeUserInterfaceStyle, object: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            #if swift(>=5.1)
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateColors(animated: true)
            }
            #endif
        }
    }

    @objc private func userInterfaceStyleDidChange() {
        updateColors(animated: true)
    }

    private func updateColors(animated: Bool) {
        func setupColors() {
            let separatorColor: UIColor = .textDisabled //DARK
            let barTintColor: UIColor = .bgPrimary
            let tintColor: UIColor = .textAction

            setBottomBorderColor(navigationBar: navigationBar, color: separatorColor, height: 0.5)
            navigationBar.barTintColor = barTintColor
            navigationBar.tintColor = tintColor
            navigationBar.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.3) {
                setupColors()
            }
        } else {
            setupColors()
        }
    }

    private func setBottomBorderColor(navigationBar: UINavigationBar, color: UIColor, height: CGFloat) {
        if hairlineView == nil {
            let bottomBorderRect = CGRect(x: 0, y: navigationBar.frame.height, width: navigationBar.frame.width, height: height)
            let view = UIView(frame: bottomBorderRect)
            navigationBar.addSubview(view)
            hairlineView = view
        }

        hairlineView?.backgroundColor = color
    }
}
