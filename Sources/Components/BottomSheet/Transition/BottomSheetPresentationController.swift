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

class BottomSheetPresentationController: UIPresentationController {

    // MARK: - Public properties

    var size: BottomSheet.Size = .zero

    // MARK: - Private properties
    // Constraint is used to set the height of the bottom sheet
    private var constraint: NSLayoutConstraint?
    private var gestureController: BottomSheetGestureController?
    private let interactionController: BottomSheetInteractionController
    private let stateController = BottomSheetStateController()
    private let springAnimator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

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
        // Add tap gesture to dismiss controller
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGesture.delegate = self
        containerView.addGestureRecognizer(tapGesture)
        // Setup views
        containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        constraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.frame.height)
        NSLayoutConstraint.activate([
            constraint!,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor),
            presentedView.heightAnchor.constraint(greaterThanOrEqualToConstant: size.compact)
        ])
        // Setup controllers
        stateController.size = size
        stateController.frame = containerView.bounds
        interactionController.setup(with: constraint)
        interactionController.stateController = stateController
        // If no expanded size if given it should be static
        guard size.expanded != nil else { return }
        gestureController = BottomSheetGestureController(presentedView: presentedView, containerView: containerView)
        gestureController?.delegate = interactionController
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If completed is false, the transition was cancelled by user interacion
        guard completed else { return }
        // Setup gesture and animation for presentation
        springAnimator.constraint = constraint
        gestureController?.delegate = self
    }

    override func dismissalTransitionWillBegin() {
        // Make sure state is dismissed
        stateController.state = .dismissed
        // Clean up animator and gesture
        springAnimator.stopAnimation()
        // Setup interaction controller for dismissal
        interactionController.initialTransitionVelocity = gestureController?.velocity ?? 0
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // Completed should always be true at this point of development
        guard !completed else { return }
    }
}

// MARK: - Private methods
private extension BottomSheetPresentationController {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
}

// MARK: - UIGesture delegate
extension BottomSheetPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let tapGesture = gestureRecognizer as? UITapGestureRecognizer else { return true }
        let location = tapGesture.location(in: containerView)
        return !presentedViewController.view.frame.contains(location)
    }
}

// MARK: - Gesture controller delegate
extension BottomSheetPresentationController: BottomSheetGestureControllerDelegate {
    // This method expects to return the current y position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGFloat {
        springAnimator.pauseAnimation()
        return constraint?.constant ?? 0
    }
    
    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController) {
        constraint?.constant = controller.position
    }

    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController) {
        stateController.updateState(withTranslation: controller.translation)
        switch stateController.state {
        case .dismissed:
            presentedViewController.dismiss(animated: true)
        default:
            springAnimator.targetPosition = stateController.targetPosition
            springAnimator.initialVelocity = controller.velocity
            springAnimator.startAnimation()
        }
    }
}
