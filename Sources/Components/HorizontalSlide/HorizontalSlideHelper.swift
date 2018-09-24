import UIKit

public class HorizontalSlideHelper: NSObject {
    
    // MARK: - Properties
    public var direction: UIRectEdge = []
    var disableCompactHeight = false
}

// MARK: - UIViewControllerTransitioningDelegate
extension HorizontalSlideHelper: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting, direction: direction)
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideAnimator(direction: direction, isPresentation: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideAnimator(direction: direction, isPresentation: false)
    }
}
