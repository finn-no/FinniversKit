//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class HorizontalSlideDemoViewController: UIViewController, Demoable {
    var overridesModalPresentationStyle: Bool { true }

    lazy var transition: HorizontalSlideTransition = {
        let transition = HorizontalSlideTransition()
        transition.delegate = self
        return transition
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = transition
        modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .bgPrimary

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizerAction))
        swipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    @objc func swipeGestureRecognizerAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension HorizontalSlideDemoViewController: HorizontalSlideTransitionDelegate {
    func horizontalSlideTransitionDidDismiss(_ horizontalSlideTransition: HorizontalSlideTransition) {
        // Do something
    }
}
