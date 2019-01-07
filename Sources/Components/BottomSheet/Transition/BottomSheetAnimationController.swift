//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

class BottomSheetAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var initialVelocity: CGPoint = .zero
    var targetPosition: CGPoint = .zero

    private let animator = SpringAnimator(dampingRatio: 0.85, frequencyResponse: 0.42)
    private var constraint: NSLayoutConstraint?

    func setup(with constraint: NSLayoutConstraint?) {
        self.constraint = constraint
        animator.addAnimation { position in
            constraint?.constant = position.y
        }
    }

    func addAnimation(_ animation: @escaping (CGPoint) -> Void) {
        animator.addAnimation(animation)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateToTargetPosition { didComplete in
            transitionContext.completeTransition(didComplete)
        }
    }

    func cancelTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateToTargetPosition { _ in
            transitionContext.completeTransition(false)
        }
    }

    func pauseTransition() {
        animator.pauseAnimation()
    }

    func continueTransition() {
        guard let constraint = constraint else { return }
        animator.fromPosition = CGPoint(x: 0, y: constraint.constant)
        animator.toPosition = targetPosition
        animator.initialVelocity = initialVelocity
        animator.startAnimation()
    }

    // Because this is a spring animation the duration is unknown
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
}

private extension BottomSheetAnimationController {
    func animateToTargetPosition(_ completion: @escaping (Bool) -> Void) {
        guard let constraint = constraint else { return }
        animator.fromPosition = CGPoint(x: 0, y: constraint.constant)
        animator.toPosition = targetPosition
        animator.initialVelocity = initialVelocity
        animator.addCompletion(completion)
        animator.startAnimation()
    }
}
