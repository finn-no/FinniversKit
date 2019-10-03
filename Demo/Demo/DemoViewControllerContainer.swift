import FinniversKit

class DemoViewControllerContainer<View: UIView>: UIViewController {

    public private(set) var containmentOptions: ContainmentOptions
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

    var childViewController: DemoViewController<View>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        let viewController = DemoViewController<View>(
            dismissType: dismissType,
            containmentOptions: containmentOptions,
            supportedInterfaceOrientations: supportedInterfaceOrientations,
            constrainToTopSafeArea: constrainToTopSafeArea,
            constrainToBottomSafeArea: constrainToBottomSafeArea)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        childViewController = viewController

        if let deviceIndex = State.lastSelectedDevice {
            let device = Device.all[deviceIndex]
            let dimensions = device.dimensions(currentTraitCollection: traitCollection)
            viewController.view.frame = dimensions.frame
            viewController.view.autoresizingMask = dimensions.autoresizingMask
            setOverrideTraitCollection(dimensions.traits, forChild: viewController)
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

extension DemoViewControllerContainer: CornerAnchoringViewDelegate {
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

extension DemoViewControllerContainer: TweakingOptionsTableViewControllerDelegate {
    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didSelectDevice device: Device) {
        let dimensions = device.dimensions(currentTraitCollection: traitCollection)
        for child in children {
            UIView.animate(withDuration: 0.3) {
                child.view.frame = dimensions.frame
                child.view.autoresizingMask = dimensions.autoresizingMask
                self.setOverrideTraitCollection(dimensions.traits, forChild: child)
            }
        }
    }

    func tweakingOptionsTableViewController(_ tweakingOptionsTableViewController: TweakingOptionsTableViewController, didDismissWithIndexPath indexPath: IndexPath?) {
        bottomSheet?.state = .dismissed
    }
}
