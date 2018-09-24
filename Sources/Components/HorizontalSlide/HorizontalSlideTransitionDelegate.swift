import UIKit

public class HorizontalSlideTransitionDelegate: NSObject {
    
    // MARK: - Properties
    private var direction: UIRectEdge = .right
    var disableCompactHeight = false
}

// MARK: - UIViewControllerTransitioningDelegate
extension HorizontalSlideTransitionDelegate: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting, direction: direction)
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator(direction: direction, isPresentation: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator(direction: direction, isPresentation: false)
    }
}
