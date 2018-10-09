//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class HorizontalSlideDemoViewController: UIViewController {
    lazy var transitionDelegate: HorizontalSlideTransitionDelegate = {
        return HorizontalSlideTransitionDelegate()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .milk

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizerAction))
        swipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    @objc func swipeGestureRecognizerAction() {
        dismiss(animated: true, completion: nil)
    }
}
