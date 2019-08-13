import FinniversKit

class NavigationController: UINavigationController {
    private var hairlineView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        updateColors()
    }

    func updateColors() {
        let barStyle: UIBarStyle
        switch Theme.currentStyle {
        case .light:
            barStyle = .default
        case .dark:
            barStyle = .black
        }
        self.setBottomBorderColor(navigationBar: self.navigationBar, color: .navigationHairlineColor, height: 0.5)
        self.navigationBar.barTintColor = .barTintColor
        self.navigationBar.tintColor = .foregroundTintColor
        self.navigationBar.barStyle = barStyle
        self.navigationBar.layoutIfNeeded()
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
