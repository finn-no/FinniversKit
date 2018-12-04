//
//  BottomSheetGestureController.swift
//  bottom-sheets
//
//  Created by Granheim Brustad , Henrik on 15/11/2018.
//  Copyright © 2018 Henrik Brustad. All rights reserved.
//

import UIKit

protocol BottomSheetGestureControllerDelegate: class {
    func gestureDidBegin() -> CGFloat // Expects to get the current position of the bottom sheet
    func gestureDidChange(position: CGFloat)
    func gestureDidEnd(with state: BottomSheetPresentationController.State, targetPosition position: CGFloat, andVelocity velocity: CGFloat)
    func currentPresentationState(for gestureController: BottomSheetGestureController) -> BottomSheetPresentationController.State
}

class BottomSheetGestureController {

    var velocity = 0 as CGFloat
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
            initialConstant = delegate?.gestureDidBegin() ?? 0

        case .changed:
            let position = initialConstant + transition.y
            delegate?.gestureDidChange(position: position)

        case .ended:
            guard let currentState = delegate?.currentPresentationState(for: self) else { return }
            let nextState = self.nextState(forTransition: transition, withCurrent: currentState, usingThreshold: threshold)
            let targetPosition = self.targetPosition(for: nextState)
            delegate?.gestureDidEnd(with: nextState, targetPosition: targetPosition, andVelocity: velocity.y)

        default:
            return
        }
    }

    func nextState(forTransition transition: CGPoint, withCurrent current: BottomSheetPresentationController.State, usingThreshold threshold: CGFloat) -> BottomSheetPresentationController.State {
        switch current {
        case .compressed:
            if transition.y < -threshold { return .expanded }
            else if transition.y > threshold { return .dismissed }
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
