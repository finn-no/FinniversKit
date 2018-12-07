//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

/**
 The presentation controller is controlling how the bottom sheet is presented.
 This object operates together with the interaction controller to create the complete transition.

 When the presentation transition begins, this object will create a gesture controller and set its delegate to the interaction controller in order to interact with the transition animation.
 After the transition if finished, this objects becomes the gesture controllers delegate and is in control of the constraint during the presentation.

 At this point, only the presenting transition is made interactive because the presentation is it self an interactive way of dismissing the bottom sheet.
**/

extension BottomSheetPresentationController {
    enum State {
        case expanded
        case compressed
        case dismissed
    }
}

class BottomSheetPresentationController: UIPresentationController {

    let interactionController: BottomSheetInteractionController
    // Constraint is used to set the y position of the bottom sheet
    private var constraint: NSLayoutConstraint?
    private var gestureController: BottomSheetGestureController?

    private var presentationState: State = .compressed
    private var springAnimator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    init(presentedViewController: UIViewController, presenting: UIViewController?, interactionController: BottomSheetInteractionController) {
        self.interactionController = interactionController
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        // Setup views
        containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        constraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.bounds.height)
        NSLayoutConstraint.activate([
            constraint!,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        // Setup gesture with interactive transition as delegate
        gestureController = BottomSheetGestureController(presentedView: presentedView, containerView: containerView)
        gestureController?.delegate = interactionController
        // Setup interactive transition for presenting
        interactionController.setup(with: constraint)
        interactionController.targetTransitionPosition = containerView.frame.height / 2
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If completed is false, the transition was cancelled by user interacion
        guard completed else { return }
        setupInteractivePresentation()
    }

    override func dismissalTransitionWillBegin() {
        // Clean up animator and gesture
        springAnimator.stopAnimation()
        // Setup interaction controller for dismissal
        interactionController.presentationState = presentationState
        interactionController.initialTransitionVelocity = gestureController?.velocity ?? 0
        interactionController.targetTransitionPosition = containerView?.frame.height ?? 0
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // Completed should always be true at this point of development
        guard !completed else { return }
        setupInteractivePresentation()
    }
}

private extension BottomSheetPresentationController {
    func setupInteractivePresentation() {
        // Setup gesture and animation for presentation
        presentationState = interactionController.presentationState
        gestureController?.delegate = self
        springAnimator.constraint = constraint
    }
}

extension BottomSheetPresentationController: BottomSheetGestureControllerDelegate {
    // This method expects to return the current y position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGFloat {
        springAnimator.pauseAnimation()
        return constraint?.constant ?? 0
    }
    // Position is the y position of the bottom sheet in the container view
    func bottomSheetGestureController(_ controller: BottomSheetGestureController, didChangeGesture position: CGFloat) {
        constraint?.constant = position
    }

    func bottomSheetGestureController(_ controller: BottomSheetGestureController, didEndGestureWith state: BottomSheetPresentationController.State, andTargetPosition position: CGFloat) {
        self.presentationState = state
        switch state {
        case .dismissed:
            presentedViewController.dismiss(animated: true)
        default:
            springAnimator.targetPosition = position
            springAnimator.initialVelocity = controller.velocity
            springAnimator.startAnimation()
        }
    }

    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State {
        return presentationState
    }
}
