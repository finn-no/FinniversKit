import UIKit

public enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

public class HorizontalSlideHelper: NSObject {
    
    // MARK: - Properties
    public var direction = PresentationDirection.left
    var disableCompactHeight = false
}

// MARK: - UIViewControllerTransitioningDelegate
extension HorizontalSlideHelper: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting, direction: direction)
        presentationController.delegate = self
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideAnimator(direction: direction, isPresentation: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideAnimator(direction: direction, isPresentation: false)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension HorizontalSlideHelper: UIAdaptivePresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
            return .overFullScreen
        } else {
            return .none
        }
    }
    
    public func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        guard case(.overFullScreen) = style else { return nil }
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RotateViewController")
    }
}
