//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

/**
 This object is controlling the animation of the transition using the animator object

 This object should be the delegate of a gesture controller during the transition in order to interact with the transition.
 The presentation controller owns the gesture controller and have to set the delegate.
 The constraint should also be provided by the presentation controller
**/
class BottomSheetInteractionController: NSObject, UIViewControllerInteractiveTransitioning {

    let animationController: BottomSheetAnimationController
    var initialTransitionVelocity = 0 as CGFloat
    var stateController: BottomSheetStateController?

    private var constraint: NSLayoutConstraint?
    private var transitionContext: UIViewControllerContextTransitioning?

    init(animationController: BottomSheetAnimationController) {
        self.animationController = animationController
    }

    func setup(with constraint: NSLayoutConstraint?) {
        self.constraint = constraint
        animationController.setup(with: constraint)
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // Keep track of context for any future transition related actions
        self.transitionContext = transitionContext
        // Start transition animation
        animationController.targetPosition = stateController?.targetPosition ?? 0
        animationController.initialVelocity = initialTransitionVelocity
        animationController.animateTransition(using: transitionContext)
    }
}

// The interaction is only used during the presentation transition
extension BottomSheetInteractionController: BottomSheetGestureControllerDelegate {
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGFloat {
        // interrupt the transition
        animationController.pauseTransition()
        return constraint?.constant ?? 0
    }

    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController) {
        // Update constraint based on gesture
        constraint?.constant = controller.height
    }

    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController) {
        guard let transitionContext = transitionContext, let stateController = stateController else { return }
        stateController.updateState(withTranslation: controller.translation)
        animationController.initialVelocity = controller.velocity
        animationController.targetPosition = stateController.targetPosition
        switch stateController.state {
        case .dismissed: animationController.cancelTransition(using: transitionContext)
        default: animationController.continueTransition()
        }
    }
}
