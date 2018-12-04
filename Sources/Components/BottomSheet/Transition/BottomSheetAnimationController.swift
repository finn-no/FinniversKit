//
//  BottomSheetAnimator.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 14/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

class BottomSheetAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var initialVelocity = 0 as CGFloat
    var targetPosition = 0 as CGFloat

    private let animator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

    func setup(with constraint: NSLayoutConstraint?) {
        animator.constraint = constraint
    }
    // Because this is a spring animation the duration is unknown
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator.targetPosition = targetPosition
        animator.initialVelocity = initialVelocity
        animator.completion = { didComplete in
            transitionContext.completeTransition(didComplete)
        }
        animator.startAnimation()
    }

    func cancelTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard animator.state == .paused else { return }
        animator.targetPosition = targetPosition
        animator.initialVelocity = initialVelocity
        animator.completion = { _ in
            transitionContext.completeTransition(false)
        }
        animator.continueAnimation()
    }

    func pauseTransition() {
        animator.pauseAnimation()
    }

    func continueTransition() {
        animator.targetPosition = targetPosition
        animator.initialVelocity = initialVelocity
        animator.continueAnimation()
    }
}
