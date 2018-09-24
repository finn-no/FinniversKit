//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class HorizontalSlideDemoViewController: UIViewController {
    lazy var customTransitionDelegate: HorizontalSlideHelper = {
        return HorizontalSlideHelper()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show horizontal slide", style: .done, target: self, action: #selector(showHorizontalSlide(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissTapped(sender:)))
    }

    @objc func showHorizontalSlide(sender: Any?) {
        let presentedViewController = UIViewController()
        presentedViewController.view.backgroundColor = .red
        let secondViewController = UINavigationController(rootViewController: presentedViewController)
        secondViewController.transitioningDelegate = customTransitionDelegate
        self.customTransitionDelegate.direction = .right
        secondViewController.modalPresentationStyle = .custom
        present(secondViewController, animated: true, completion: nil)
    }

    @objc func dismissTapped(sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}
