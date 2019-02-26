//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class FullscreenGalleryDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Public properties

    public var dismissVelocity: CGPoint?

    // MARK: - Private properties

    private let animationDuration = 0.5
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
        guard let presenterView = presenterDelegate.imageViewForFullscreenGalleryTransition() else {
            return
        }

        guard let presentedView = destinationDelegate.imageViewForFullscreenGalleryTransition() else {
            return
        }

        let presenterFrame = presenterView.convert(presenterView.bounds, to: transitionContext.containerView)
        let presentedFrame = presentedView.convert(presentedView.bounds, to: transitionContext.containerView)

        let transitionView = createImageView(from: presentedView)
        transitionView.frame = presentedFrame
        transitionContext.containerView.addSubview(transitionView)

        presenterView.isHidden = true
        presentedView.isHidden = true

        destinationDelegate.prepareForTransition(presenting: false)

        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            self.performBezierAnimation(onView: transitionView, from: presentedFrame, to: presenterFrame)
            transitionView.bounds = CGRect(x: 0, y: 0, width: presenterFrame.width, height: presenterFrame.height)

            self.destinationDelegate.performTransitionAnimation(presenting: false)
        }, completion: { _ in
            transitionView.removeFromSuperview()
            presenterView.isHidden = false
            presentedView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    // MARK: - Private methods

    private func performBezierAnimation(onView view: UIView, from: CGRect, to: CGRect) {
        let bezierPath = calculateBezier(from: from, to: to)

        // Perform the animations
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        CATransaction.setAnimationDuration(animationDuration)

        let bezierAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        bezierAnimation.path = bezierPath.cgPath
        bezierAnimation.fillMode = .forwards
        bezierAnimation.isRemovedOnCompletion = false
        view.layer.add(bezierAnimation, forKey: nil)

        CATransaction.commit()
    }

    private func calculateBezier(from fromFrame: CGRect, to toFrame: CGRect) -> UIBezierPath {
        // The CA-layers deal with anchorPoint=[0.5, 0.5], so we need to adjust the positions to be
        // centered in the source & destination frames.
        let fromFrameOffset = CGPoint(x: fromFrame.width / 2.0, y: fromFrame.height / 2.0)
        let toFrameOffset = CGPoint(x: toFrame.width / 2.0, y: toFrame.height / 2.0)

        // The raw velocity seems to be quite exaggerated, and dividing it by 10 makes the
        // path seem way more natural and in line with the actual velocity of the motion.
        let adjustedVelocity = (dismissVelocity ?? CGPoint.zero) / 10.0
        let path = UIBezierPath()

        let p1 = fromFrame.origin + fromFrameOffset
        let p2 = toFrame.origin + toFrameOffset

        let c1 = p1 + adjustedVelocity
        let c2 = p2 + (adjustedVelocity * 0.5)

        path.move(to: p1)
        path.addCurve(to: p2, controlPoint1: c1, controlPoint2: c2)

        return path
    }

    private func createImageView(from: UIImageView) -> UIImageView {
        let imageView = UIImageView(image: from.image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
