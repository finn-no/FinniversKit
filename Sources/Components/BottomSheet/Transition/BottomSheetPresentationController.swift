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

    var state: BottomSheet.State {
        get { return stateController.state }
        set { updateState(newValue) }
    }

    weak var dismissalDelegate: BottomSheetDismissalDelegate?
    private let height: BottomSheet.Height
    private let interactionController: BottomSheetInteractionController
    private var constraint: NSLayoutConstraint? // Constraint is used to set the y position of the bottom sheet
    private var gestureController: BottomSheetGestureController?
    private let springAnimator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)
    private lazy var stateController = BottomSheetStateController(height: height)

    private var hasReachExpandedPosition = false
    private var currentPosition: CGPoint {
        guard let constraint = constraint else { return .zero }
        return CGPoint(x: 0, y: constraint.constant)
    }

    override var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    private lazy var dimView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        return view
    }()

    init(presentedViewController: UIViewController, presenting: UIViewController?, height: BottomSheet.Height, interactionController: BottomSheetInteractionController) {
        self.height = height
        self.interactionController = interactionController
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let bottomSheet = presentedViewController as? BottomSheet else { return }
        setupDimView(dimView, inContainerView: containerView)
        setupPresentedView(bottomSheet.view, inContainerView: containerView)
        // Setup controller
        stateController.frame = containerView.bounds
        gestureController = BottomSheetGestureController(bottomSheet: bottomSheet, containerView: containerView)
        gestureController?.delegate = interactionController
        interactionController.setup(with: constraint)
        interactionController.stateController = stateController
        interactionController.dimView = dimView
        // Setup animations
        springAnimator.addAnimation { [weak self] position in
            self?.constraint?.constant = position.y
            self?.dimView.alpha = self?.alphaValue(for: position) ?? 0
        }
        // Animate dim view alpha in sync with transition animation
        interactionController.animate { [weak self] position in
            self?.dimView.alpha = self?.alphaValue(for: position) ?? 0
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If completed is false, the transition was cancelled by user interaction
        guard completed else { return }
        gestureController?.delegate = self
    }

    override func dismissalTransitionWillBegin() {
        springAnimator.stopAnimation(true)
        // Make sure initial transition velocity is the same the current velocity of the bottom sheet
        interactionController.initialTransitionVelocity = -(gestureController?.velocity ?? .zero)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // Completed should always be true at this point of development
        guard !completed else { return }
        gestureController?.delegate = self
    }
}

private extension BottomSheetPresentationController {
    func setupDimView(_ dimView: UIView, inContainerView containerView: UIView) {
        containerView.addSubview(dimView)
        dimView.fillInSuperview()
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    func setupPresentedView(_ presentedView: UIView, inContainerView containerView: UIView) {
        containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.bounds.height)
        NSLayoutConstraint.activate([
            constraint,
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.heightAnchor.constraint(greaterThanOrEqualToConstant: height.compact),
            presentedView.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor),
        ])
        self.constraint = constraint
    }

    func alphaValue(for position: CGPoint) -> CGFloat {
        guard let containerView = containerView else { return 0 }
        return (containerView.bounds.height - position.y) / height.compact
    }

    func updateState(_ state: BottomSheet.State) {
        guard state != stateController.state else { return }
        stateController.state = state
        animate(to: stateController.targetPosition)
    }

    @objc func handleTap() {
        stateController.state = .dismissed
        gestureController?.velocity = .zero
        presentedViewController.dismiss(animated: true)
    }

    func animate(to position: CGPoint, initialVelocity: CGPoint = .zero) {
        switch stateController.state {
        case .dismissed:
            presentedViewController.dismiss(animated: true)
            dismissalDelegate?.bottomSheetDidDismiss()
        default:
            springAnimator.fromPosition = currentPosition
            springAnimator.toPosition = position
            springAnimator.initialVelocity = initialVelocity
            springAnimator.startAnimation()
        }
    }
}

extension BottomSheetPresentationController: BottomSheetGestureControllerDelegate {
    // This method expects to return the current position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGPoint {
        guard let constraint = constraint, constraint.constant > stateController.expandedPosition.y else {
            hasReachExpandedPosition = true
            return currentPosition
        }
        springAnimator.pauseAnimation()
        return currentPosition
    }
    // Position is the position of the bottom sheet in the container view
    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController) {
        if controller.position.y <= stateController.expandedPosition.y {
            guard !hasReachExpandedPosition else { return }
            hasReachExpandedPosition = true
            animate(to: stateController.expandedPosition, initialVelocity: -controller.velocity)
            return
        }

        hasReachExpandedPosition = false
        dimView.alpha = alphaValue(for: controller.position)
        constraint?.constant = controller.position.y
    }

    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController) {
        stateController.updateState(withTranslation: controller.translation)
        guard !hasReachExpandedPosition else { return }
        animate(to: stateController.targetPosition, initialVelocity: -controller.velocity)
    }
}
