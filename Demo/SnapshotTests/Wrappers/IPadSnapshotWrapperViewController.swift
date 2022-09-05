import UIKit

class IPadSnapshotWrapperViewController: SnapshotWrapperViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let overriddenTraitCollection = UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: .light),
            UITraitCollection(horizontalSizeClass: .regular)
        ])
        setOverrideTraitCollection(overriddenTraitCollection, forChild: demoViewController)
    }
}
