import UIKit

@objc public protocol HorizontalSlideTransitionDelegate: AnyObject {
    @objc func horizontalSlideTransitionDidDismiss(_ horizontalSlideTransition: HorizontalSlideTransition)
}

public class HorizontalSlideTransition: NSObject, UIViewControllerTransitioningDelegate {
    @objc public weak var delegate: HorizontalSlideTransitionDelegate?

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting)
        presentationController.dismissalDelegate = self
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator()
    }
}

// MARK: - HorizontalSlideControllerDelegate

extension HorizontalSlideTransition: HorizontalSlideControllerDelegate {
    func horizontalSlideControllerDidDismiss(_ horizontalSlideController: HorizontalSlideController) {
        delegate?.horizontalSlideTransitionDidDismiss(self)
    }
}
