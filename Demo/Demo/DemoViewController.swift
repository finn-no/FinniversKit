import FinniversKit

class DemoViewController<View: UIView>: UIViewController {

    private(set) var containmentOptions: ContainmentOptions
    private var dismissType: DismissType
    private var preferredInterfaceOrientation: UIInterfaceOrientationMask = .all
    private let constrainToBottomSafeArea: Bool
    private let constrainToTopSafeArea: Bool
    private var bottomSheet: BottomSheet?

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

    var childViewController: BaseDemoViewController<View>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        let viewController = BaseDemoViewController<View>(
            dismissType: dismissType,
            containmentOptions: containmentOptions,
            supportedInterfaceOrientations: supportedInterfaceOrientations,
            constrainToTopSafeArea: constrainToTopSafeArea,
            constrainToBottomSafeArea: constrainToBottomSafeArea)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        childViewController = viewController

        if let deviceIndex = State.lastSelectedDevice, deviceIndex < Device.all.count {
            let device = Device.all[deviceIndex]
            viewController.view.frame = device.frame
            viewController.view.autoresizingMask = device.autoresizingMask
            setOverrideTraitCollection(device.traits, forChild: viewController)
        }

        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        if !TestCheck.isTesting {
            let tweakablePlaygroundView = (childViewController?.playgroundView as? Tweakable) ?? (self as? Tweakable)
            let options = tweakablePlaygroundView?.tweakingOptions ?? [TweakingOption]()
            let overlayView = CornerAnchoringView(withAutoLayout: true)
            overlayView.itemsCount = options.count
            overlayView.delegate = self
            view.addSubview(overlayView)
            overlayView.fillInSuperview()
        }
    }
}

extension DemoViewController: CornerAnchoringViewDelegate {
    func cornerAnchoringViewDidSelectTweakButton(_ cornerAnchoringView: CornerAnchoringView) {
        let tweakablePlaygroundView = (childViewController?.playgroundView as? Tweakable) ?? (self as? Tweakable)
        let options = tweakablePlaygroundView?.tweakingOptions ?? [TweakingOption]()
        let tweakingController = TweakingOptionsTableViewController(options: options)
        tweakingController.delegate = self
        let navigationController = NavigationController(rootViewController: tweakingController)
        navigationController.hairlineIsHidden = true
        bottomSheet = BottomSheet(rootViewController: navigationController, draggableArea: .everything)
        if let controller = bottomSheet {
            present(controller, animated: true)
        }
    }
}

extension DemoViewController: TweakingOptionsTableViewControllerDelegate {
    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didSelectDevice device: Device) {
        for child in children {
            UIView.animate(withDuration: 0.3) {
                child.view.frame = device.frame
                child.view.autoresizingMask = device.autoresizingMask
                self.setOverrideTraitCollection(device.traits, forChild: child)
            }
        }
    }

    func tweakingOptionsTableViewControllerDidDismiss(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController) {
        bottomSheet?.state = .dismissed
    }
}
