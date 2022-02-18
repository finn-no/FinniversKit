import UIKit

class SnapshotWrapperViewController: UIViewController {
    // MARK: - Internal properties

    let demoViewController: UIViewController

    // MARK: - Init

    init(demoViewController: UIViewController) {
        self.demoViewController = demoViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(demoViewController.view)
        addChild(demoViewController)
        demoViewController.didMove(toParent: self)

        let lightModeTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        setOverrideTraitCollection(lightModeTraitCollection, forChild: demoViewController)
    }
}
