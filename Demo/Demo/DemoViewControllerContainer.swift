import UIKit

class DemoViewControllerContainer<View: UIView>: UIViewController {

    public private(set) var containmentOptions: ContainmentOptions
    private var dismissType: DismissType
    private var preferredInterfaceOrientation: UIInterfaceOrientationMask = .all
    private let constrainToBottomSafeArea: Bool
    private let constrainToTopSafeArea: Bool

    public init(dismissType: DismissType = .doubleTap,
                containmentOptions: ContainmentOptions = .none,
                supportedInterfaceOrientations: UIInterfaceOrientationMask = .all,
                constrainToTopSafeArea: Bool = true,
                constrainToBottomSafeArea: Bool = true) {
        self.dismissType = dismissType
        self.containmentOptions = containmentOptions
        self.preferredInterfaceOrientation = supportedInterfaceOrientations
        self.constrainToBottomSafeArea = constrainToBottomSafeArea
        self.constrainToTopSafeArea = constrainToTopSafeArea
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = DemoViewController<View>(
            dismissType: dismissType,
            containmentOptions: containmentOptions,
            supportedInterfaceOrientations: supportedInterfaceOrientations,
            constrainToTopSafeArea: constrainToTopSafeArea,
            constrainToBottomSafeArea: constrainToBottomSafeArea)
        viewController.delegate = self
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        if let deviceIndex = State.lastSelectedDevice {
            let device = Device.all[deviceIndex]
            let dimensions = device.dimensions(orientation: .portrait)
            viewController.view.frame = dimensions.frame
            for child in children {
                setOverrideTraitCollection(dimensions.traits, forChild: child)
            }
        }

        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension DemoViewControllerContainer: DemoViewControllerDelegate {
    func demoViewControllerDidChangeDevice(device: Device) {
        let dimensions = device.dimensions(orientation: .portrait)
        for child in children {
            UIView.animate(withDuration: 0.3) {
                child.view.frame = dimensions.frame
                self.setOverrideTraitCollection(dimensions.traits, forChild: child)
            }
        }
    }
}
