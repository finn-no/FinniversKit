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
        setup()
    }

    private func setup() {
        navigationBar.isTranslucent = false
        let separatorColor: UIColor = .textDisabled //DARK
        let barTintColor: UIColor = .bgPrimary
        let tintColor: UIColor = .textAction

        setBottomBorderColor(navigationBar: navigationBar, color: separatorColor, height: 0.5)
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
        navigationBar.layoutIfNeeded()
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
