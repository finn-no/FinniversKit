//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension IndexPath {
    private static let lastSelectedRowKey = "lastSelectedRowKey"
    private static let lastSelectedSectionKey = "lastSelectedSectionKey"

    static var lastSelected: IndexPath? {
        get {
            guard let row = UserDefaults.standard.object(forKey: lastSelectedRowKey) as? Int else { return nil }
            guard let section = UserDefaults.standard.object(forKey: lastSelectedSectionKey) as? Int else { return nil }
            return IndexPath(row: row, section: section)
        }
        set {
            if let row = newValue?.row {
                UserDefaults.standard.set(row, forKey: lastSelectedRowKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedRowKey)
            }

            if let section = newValue?.section {
                UserDefaults.standard.set(section, forKey: lastSelectedSectionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedSectionKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
}

class SplitViewController: UISplitViewController {
    lazy var alternativeViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .milk

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        viewController.view.addGestureRecognizer(doubleTap)
        return viewController
    }()

    convenience init(masterViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)

        viewControllers = [masterViewController, alternativeViewController]
        setup()
    }

    convenience init(detailViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)

        viewControllers = [alternativeViewController, detailViewController]
        setup()
    }

    func setup() {
        preferredDisplayMode = .allVisible
    }

    @objc func didDoubleTap() {
        IndexPath.lastSelected = nil
        dismiss(animated: true, completion: nil)
    }
}
