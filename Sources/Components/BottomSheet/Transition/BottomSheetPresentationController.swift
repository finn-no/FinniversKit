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

    private let height: BottomSheet.Height
    private let interactionController: BottomSheetInteractionController
    private var constraint: NSLayoutConstraint? // Constraint is used to set the y position of the bottom sheet
    private var gestureController: BottomSheetGestureController?
    private let stateController = BottomSheetStateController()
    private let springAnimator = SpringAnimator(dampingRatio: 0.78, frequencyResponse: 0.5)

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
        guard let containerView = containerView, let presentedView = presentedView else { return }
        setupDimView(dimView, inContainerView: containerView)
        setupPresentedView(presentedView, inContainerView: containerView)
        // Setup controller
        stateController.frame = containerView.bounds
        stateController.height = height
        gestureController = BottomSheetGestureController(presentedView: presentedView, containerView: containerView)
        gestureController?.delegate = interactionController
        interactionController.setup(with: constraint)
        interactionController.stateController = stateController
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

    @objc func handleTap() {
        stateController.state = .dismissed
        gestureController?.velocity = .zero
        presentedViewController.dismiss(animated: true)
    }
}

extension BottomSheetPresentationController: BottomSheetGestureControllerDelegate {
    // This method expects to return the current position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGPoint {
        guard let constraint = constraint else { return .zero }
        springAnimator.pauseAnimation()
        return CGPoint(x: 0, y: constraint.constant)
    }
    // Position is the position of the bottom sheet in the container view
    func bottomSheetGestureControllerDidChangeGesture(_ controller: BottomSheetGestureController) {
        dimView.alpha = alphaValue(for: controller.position)
        constraint?.constant = controller.position.y
    }

    func bottomSheetGestureControllerDidEndGesture(_ controller: BottomSheetGestureController) {
        guard let constraint = constraint else { return }
        stateController.updateState(withTranslation: controller.translation)
        switch stateController.state {
        case .dismissed:
            presentedViewController.dismiss(animated: true)
        default:
            springAnimator.fromPosition = CGPoint(x: 0, y: constraint.constant)
            springAnimator.toPosition = stateController.targetPosition
            springAnimator.initialVelocity = -controller.velocity
            springAnimator.startAnimation()
        }
    }
}
