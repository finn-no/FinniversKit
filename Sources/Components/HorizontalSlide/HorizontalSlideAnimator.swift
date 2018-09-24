import UIKit

final class HorizontalSlideAnimator: NSObject {

    // MARK: - Properties
    let direction: UIRectEdge
    let isPresentation: Bool

    // MARK: - Initializers
    init(direction: UIRectEdge, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension HorizontalSlideAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        guard let controller = transitionContext.viewController(forKey: key) else { return }

        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame

        if direction == .top {
            dismissedFrame.origin.y = -presentedFrame.height
        } else if direction == .bottom {
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        } else if direction == .left {
            dismissedFrame.origin.x = -presentedFrame.width
        } else if direction == .right {
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        } else {
            fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }

        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame

        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
