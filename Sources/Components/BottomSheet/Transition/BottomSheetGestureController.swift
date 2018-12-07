//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

protocol BottomSheetGestureControllerDelegate: class {
    // Expects to get the current position of the bottom sheet
    func bottomSheetGestureControllerDidBeginGesture(_ controller: BottomSheetGestureController) -> CGFloat
    func bottomSheetGestureController(_ controller: BottomSheetGestureController, didChangeGesture position: CGFloat)
    func bottomSheetGestureController(_ controller: BottomSheetGestureController, didEndGestureWith state: BottomSheetPresentationController.State, andTargetPosition position: CGFloat)
    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State
}

class BottomSheetGestureController {

    var velocity: CGFloat = 0
    weak var delegate: BottomSheetGestureControllerDelegate?

    private var initialConstant = 0 as CGFloat
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
    private let presentedView: UIView
    private let containerView: UIView

    private var minValue = 44 as CGFloat
    private var threshold = 75 as CGFloat

    init(presentedView: UIView, containerView: UIView) {
        self.presentedView = presentedView
        self.containerView = containerView
        presentedView.addGestureRecognizer(panGesture)
    }
}

private extension BottomSheetGestureController {
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: containerView)
        let velocity = gesture.velocity(in: containerView)
        self.velocity = velocity.y

        switch gesture.state {
        case .began:
            initialConstant = delegate?.bottomSheetGestureControllerDidBeginGesture(self) ?? 0

        case .changed:
            let position = initialConstant + transition.y
            delegate?.bottomSheetGestureController(self, didChangeGesture: position)

        case .ended:
            guard let currentState = delegate?.currentPresentationState(for: self) else { return }
            let nextState = self.nextState(forTransition: transition, withCurrent: currentState, usingThreshold: threshold)
            let targetPosition = self.targetPosition(for: nextState)
            delegate?.bottomSheetGestureController(self, didEndGestureWith: nextState, andTargetPosition: targetPosition)

        default:
            return
        }
    }

    func nextState(forTransition transition: CGPoint, withCurrent current: BottomSheetPresentationController.State, usingThreshold threshold: CGFloat) -> BottomSheetPresentationController.State {
        switch current {
        case .compressed:
            if transition.y < -threshold {
                return .expanded
            } else if transition.y > threshold { return .dismissed }
        case .expanded:
            if transition.y > threshold { return .compressed }
        case .dismissed:
            if transition.y < -threshold { return .compressed }
        }
        return current
    }

    func targetPosition(for state: BottomSheetPresentationController.State) -> CGFloat {
        switch state {
        case .compressed:
            return containerView.frame.height / 2
        case .expanded:
            return minValue
        case .dismissed:
            return containerView.frame.height
        }
    }
}
