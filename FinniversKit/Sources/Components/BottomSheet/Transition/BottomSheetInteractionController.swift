//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

protocol BottomSheetInteractionControllerDelegate: AnyObject {
    func bottomSheetInteractionControllerWillCancelPresentationTransition(_ interactionController: BottomSheetInteractionController)
}

/**
 This object is controlling the animation of the transition using the animator object

 This object should be the delegate of a gesture controller during the transition in order to interact with the transition.
 The presentation controller owns the gesture controller and have to set the delegate.
 The constraint should also be provided by the presentation controller
**/
class BottomSheetInteractionController: NSObject, UIViewControllerInteractiveTransitioning {

    let animationController: BottomSheetAnimationController
    var initialTransitionVelocity: CGPoint = .zero
    var stateController: BottomSheetStateController?
    var dimView: UIView?

    weak var delegate: BottomSheetInteractionControllerDelegate?

    private var constraint: NSLayoutConstraint?
    private var transitionContext: UIViewControllerContextTransitioning?

    private var hasReachExpandedPosition = false
    private var currentPosition: CGPoint {
        guard let constraint = constraint else { return .zero }
        return CGPoint(x: 0, y: constraint.constant)
    }

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
        animationController.targetPosition = stateController?.targetPosition ?? .zero
        animationController.initialVelocity = initialTransitionVelocity
        animationController.animateTransition(using: transitionContext)
    }

    func animate(alongsideTransition animation: @escaping (CGPoint) -> Void) {
        animationController.addAnimation(animation)
    }
}

private extension BottomSheetInteractionController {
    func alphaValue(for position: CGPoint) -> CGFloat {
        guard let stateController = stateController else { return 0 }
        return (stateController.frame.height - position.y) / stateController.height.compact
    }
}

// The interaction is only used during the presentation transition
extension BottomSheetInteractionController: BottomSheetGestureControllerDelegate {
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGPoint {
        guard let constraint = constraint, let stateController = stateController, constraint.constant > stateController.expandedPosition.y else {
            hasReachExpandedPosition = true
            return currentPosition
        }
        animationController.pauseTransition()
        animationController.setSpringParameters(dampingRatio: 0.78, frequencyResponse: 0.5)
        return currentPosition
    }

    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController) {
        guard let stateController = stateController else { return }
        if controller.position.y <= stateController.expandedPosition.y {
            guard !hasReachExpandedPosition else { return }
            hasReachExpandedPosition = true
            animationController.targetPosition = stateController.expandedPosition
            animationController.initialVelocity = -controller.velocity
            animationController.continueTransition()
            return
        }

        hasReachExpandedPosition = false
        dimView?.alpha = alphaValue(for: controller.position)
        constraint?.constant = controller.position.y
    }

    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController) {
        guard let transitionContext = transitionContext, let stateController = stateController else { return }
        stateController.updateState(withTranslation: controller.translation)
        guard !hasReachExpandedPosition else { return }
        animationController.initialVelocity = -controller.velocity
        animationController.targetPosition = stateController.targetPosition
        switch stateController.state {
        case .dismissed:
            delegate?.bottomSheetInteractionControllerWillCancelPresentationTransition(self)
            animationController.cancelTransition(using: transitionContext)
        default:
            animationController.continueTransition()
        }
    }
}
