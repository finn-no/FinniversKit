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
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapped))
        viewController.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func tapped() {
        for child in children {
            let traits = UITraitCollection(traitsFrom: [
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(userInterfaceIdiom: .phone)
            ])

            let width: CGFloat = 320
            let height: CGFloat = 568
            // swiftlint:disable:next identifier_name
            let x: CGFloat = (UIScreen.main.bounds.width - width) / 2
            // swiftlint:disable:next identifier_name
            let y: CGFloat = (UIScreen.main.bounds.height - height) / 2

            UIView.animate(withDuration: 0.3) {
                self.view.frame = .init(x: x, y: y, width: width, height: height)
                self.setOverrideTraitCollection(traits, forChild: child)
            }
        }
    }
}
