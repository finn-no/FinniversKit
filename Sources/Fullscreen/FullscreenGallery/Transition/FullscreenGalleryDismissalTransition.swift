//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class FullscreenGalleryDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Public properties

    public var dismissVelocity: CGPoint?

    // MARK: - Private properties

    private let animationDuration = 0.75
    private let presenterDelegate: FullscreenGalleryTransitionPresenterDelegate
    private let destinationDelegate: FullscreenGalleryTransitionDestinationDelegate

    // MARK: - Init

    required init(toPresenter presenter: FullscreenGalleryTransitionPresenterDelegate, fromDestination destination: FullscreenGalleryTransitionDestinationDelegate) {
        presenterDelegate = presenter
        destinationDelegate = destination
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presenterViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let presenterView = presenterDelegate.viewForFullscreenGalleryTransition()
        let presenterFrame = presenterView.convert(presenterView.bounds, to: transitionContext.containerView)

        let presentedView = destinationDelegate.viewForFullscreenGalleryTransition()
        let presentedFrame = presentedView.convert(presentedView.bounds, to: transitionContext.containerView)

        let transitionView = presentedView.snapshotView(afterScreenUpdates: true)!
        transitionView.frame = presentedFrame
        transitionContext.containerView.addSubview(transitionView)

        presenterView.isHidden = true
        presentedView.isHidden = true

        destinationDelegate.prepareForTransition(presenting: false)

        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            if !self.performBezierAnimation(onView: transitionView, from: presentedFrame, to: presenterFrame) {
                transitionView.frame = presenterFrame
            }

            self.destinationDelegate.performTransitionAnimation(presenting: false)
        }, completion: { _ in
            transitionView.removeFromSuperview()
            presenterView.isHidden = false
            presentedView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    // MARK: - Private methods

    private func performBezierAnimation(onView view: UIView, from: CGRect, to: CGRect) -> Bool {
        guard let bezierPath = calculateBezier(from: from, to: to) else {
            return false
        }

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(animationDuration)

        let bezierAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        bezierAnimation.path = bezierPath.cgPath
        bezierAnimation.fillMode = .forwards
        bezierAnimation.isRemovedOnCompletion = false
        view.layer.add(bezierAnimation, forKey: nil)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = [CGFloat(1.0), CGFloat(1.0)]
        scaleAnimation.toValue = [CGFloat(to.width / from.width), CGFloat(to.height / from.height)]
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        view.layer.add(scaleAnimation, forKey: nil)

        CATransaction.commit()

        return true
    }

    private func calculateBezier(from fromFrame: CGRect, to toFrame: CGRect) -> UIBezierPath? {
        guard let rawVelocity = dismissVelocity else {
            return nil
        }

        let velocity = rawVelocity / 10.0

        let path = UIBezierPath()

        let p1 = fromFrame.origin
        let p2 = toFrame.origin

        let c1 = (p1 + velocity)
        let c1ToP2 = c1 - p2
        let p2PlusVelocity = p2 + velocity
        let c2 = (c1ToP2 + p2PlusVelocity) / 2.0

        path.move(to: p1)
        path.addCurve(to: p2, controlPoint1: c1, controlPoint2: c2)

        return path
    }
}
