//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let animationController: BottomSheetTransitioningAnimator
    private var presentationController: BottomSheetPresentationController?

    private weak var _presentationControllerDelegate: BottomSheetPresentationControllerDelegate?

    public var presentationControllerDelegate: BottomSheetPresentationControllerDelegate? {
        get {
            return presentationController?.delegate as? BottomSheetPresentationControllerDelegate
        }
        set(delegate) {
            _presentationControllerDelegate = delegate
        }
    }

    public init(for viewController: UIViewController) {
        animationController = BottomSheetTransitioningAnimator()
        super.init()

        viewController.modalPresentationStyle = .custom
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.transitionType = .presentation
        return animationController
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.transitionType = .dismissal
        return animationController
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactiveDismissalController = presentationController?.interactiveDismissalController, interactiveDismissalController.isInteractionActive {
            return interactiveDismissalController
        }
        return nil
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard let presentationController = presentationController else {
            self.presentationController = BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
            self.presentationController?.delegate = _presentationControllerDelegate
            return self.presentationController
        }

        return presentationController
    }
}
